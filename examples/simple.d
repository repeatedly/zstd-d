import zstd.zstd;
static import std.file;
static import std.stdio;

void main(string[] args)
{
    if (args.length <= 1)
        throw new Exception("Must specify filename");

    // second argument is compression level between 1 - 22
    auto compressed = compress(std.file.read(args[1]), 3);
    auto uncompressed = uncompress(compressed);
    std.stdio.writeln(cast(string)uncompressed);
}
