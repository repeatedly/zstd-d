import zstd;
static import std.file;
static import std.stdio;

void main(string[] args)
{
    if (args.length <= 1)
        throw new Exception("Must specify filename");

    auto original = std.file.read(args[1]);
    auto compressed = compress(original, 3);  // second argument is compression level between 1 - 22

    std.stdio.writefln("original size:   %d", original.length);
    std.stdio.writefln("compressed size: %d", compressed.length);

    auto uncompressed = uncompress(compressed);

    assert(original == uncompressed, "uncompression failed");
}
