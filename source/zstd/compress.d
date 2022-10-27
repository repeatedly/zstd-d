module zstd.compress;

import zstd.c.zstd;
import zstd.common;

enum Level : int
{
    base = 3,
    mix = 1,
    max = 22,
    speed = 1,
    size = 22,
}

ubyte[] compress(const(void)[] src, int level = Level.base)
{
    auto destCap = ZSTD_compressBound(src.length);
    auto destBuf = new ubyte[destCap];
    auto result = ZSTD_compress(destBuf.ptr, destCap, src.ptr, src.length, level);
    if (ZSTD_isError(result)) {
        destBuf = null;
        throw new ZstdException(result);
    }

    return destBuf[0..result];
}

class Compressor
{
  private:
    ZSTD_CStream* cstream;
    ubyte[] buffer;

  public:
    @property @trusted static
    {
        size_t recommendedInSize()
        {
            return ZSTD_CStreamInSize();
        }

        size_t recommendedOutSize()
        {
            return ZSTD_CStreamOutSize();
        }
    }

    this(int level = Level.base)
    in
    {
        assert(Level.min <= level && level <= Level.max);
    }
    do
    {
        cstream = ZSTD_createCStream();
        buffer = new ubyte[](recommendedOutSize);
        size_t result = ZSTD_initCStream(cstream, level);
        if (ZSTD_isError(result))
            throw new ZstdException(result);
    }

    ~this()
    {
        closeStream();
    }

    ubyte[] compress(const(void)[] src)
    {
        ubyte[] result;
        ZSTD_inBuffer input = {src.ptr, src.length, 0};
        ZSTD_outBuffer output = {buffer.ptr, buffer.length, 0};

        while (input.pos < input.size) {
            output.pos = 0;
            size_t code = ZSTD_compressStream(cstream, &output, &input);
            if (ZSTD_isError(code))
                throw new ZstdException(code);
            result ~= buffer[0..output.pos];
        }

        return result;
    }

    ubyte[] flush()
    {
        ZSTD_outBuffer output = {buffer.ptr, buffer.length, 0};

        size_t code = ZSTD_flushStream(cstream, &output);
        if (ZSTD_isError(code))
            throw new ZstdException(code);

        return buffer[0..output.pos];
    }

    ubyte[] finish()
    {
        ZSTD_outBuffer output = {buffer.ptr, buffer.length, 0};

        size_t remainingToFlush = ZSTD_endStream(cstream, &output);
        // TODO: Provide finish(ref size_t remainingToFlush) version?
        if (remainingToFlush > 0)
            throw new ZstdException("not fully flushed.");
        closeStream();

        return buffer[0..output.pos];
    }

  private:
    void closeStream()
    {
        if (cstream) {
            ZSTD_freeCStream(cstream);
            cstream = null;
        }
    }
}
