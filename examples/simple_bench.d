static import std.file;
import std.stdio;
import std.datetime;
import std.typetuple;

void main(string[] args)
{
    auto source = std.file.read(args[1]);

    void zlib()
    {
        import std.zlib;

        auto r1 = compress(source, 1);
        auto r2 = uncompress(r1);
    }

    void zstd()
    {
        import zstd;

        auto r1 = compress(source, 1);
        auto r2 = uncompress(r1);
    }

    alias TypeTuple!(zlib, zstd) Funcs;

    immutable num = 10000;
    auto times = benchmark!(Funcs)(num);
    writeln(num, " loops (msecs) : smaller is better");
    writeln("zlib: ", times[0].msecs);
    writeln("zstd: ", times[1].msecs);
}
