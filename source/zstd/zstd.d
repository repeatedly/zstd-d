module zstd.zstd;

import zstd.c.zstd;

class ZstdException : Exception
{
    @trusted
    this(string msg, string filename = __FILE__, size_t line = __LINE__)
    {
        super(msg, filename, line);
    }

    @trusted
    this(size_t code, string filename = __FILE__, size_t line = __LINE__)
    {
        import std.string : fromStringz;
        super(cast(string)ZSTD_getErrorName(code).fromStringz, filename, line);
    }
}

ubyte[] compress(const(void)[] src, int level = 1)
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
