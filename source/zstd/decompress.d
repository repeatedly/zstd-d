module zstd.decompress;

import zstd.c.zstd;
import zstd.common;

void[] uncompress(const(void)[] src)
{
    auto destCap = ZSTD_getDecompressedSize(src.ptr, src.length);
    if (destCap == 0)
        throw new ZstdException("Unknown original size. Use stream API");

    auto destBuf = new ubyte[destCap];
    auto result = ZSTD_decompress(destBuf.ptr, destCap, src.ptr, src.length);
    if (ZSTD_isError(result)) {
        destBuf = null;
        throw new ZstdException(result);
    }

    return destBuf[0..result];
}

class Decompressor
{
  private:
    ZSTD_DStream* dstream;
    ubyte[] buffer;

  public:
    @property @trusted static
    {
        size_t recommendedInSize()
        {
            return ZSTD_DStreamInSize();
        }

        size_t recommendedOutSize()
        {
            return ZSTD_DStreamOutSize();
        }
    }

    this()
    {
        dstream = ZSTD_createDStream();
        buffer = new ubyte[](recommendedOutSize);
        size_t result = ZSTD_initDStream(dstream);
        if (ZSTD_isError(result))
            throw new ZstdException(result);
    }

    ~this()
    {
        closeStream();
    }

    ubyte[] uncompress(const(void)[] src)
    {
        ubyte[] result;
        ZSTD_inBuffer input = {src.ptr, src.length, 0};
        ZSTD_outBuffer output = {buffer.ptr, buffer.length, 0};

        while (input.pos < input.size) {
            output.pos = 0;
            size_t code = ZSTD_decompressStream(dstream, &output, &input);
            if (ZSTD_isError(code))
                throw new ZstdException(code);
            result ~= buffer[0..output.pos];
        }

        return result;
    }

    ubyte[] flush()
    {
        return null;
    }

    ubyte[] finish()
    {
        closeStream();

        return null;
    }

  private:
    void closeStream()
    {
        if (dstream) {
            ZSTD_freeDStream(dstream);
            dstream = null;
        }
    }
}

