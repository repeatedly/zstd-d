module zstd.common;

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
