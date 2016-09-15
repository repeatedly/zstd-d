import zstd;
static import std.file;
static import std.stdio;

void main(string[] args)
{
    if (args.length <= 1)
        throw new Exception("Must specify filename");

    ubyte[] original = cast(ubyte[])std.file.read(args[1]);
    ubyte[][] contents1;
    contents1 ~= original[0..$ / 2];
    contents1 ~= original[$ / 2..$];

    ubyte[] compressed;
    auto compressor = new Compressor();
    foreach (src; contents1)
        compressed ~= compressor.compress(src);
    compressed ~= compressor.flush();

    std.stdio.writefln("original size:   %d", original.length);
    std.stdio.writefln("compressed size: %d", compressed.length);

    ubyte[][] contents2;
    contents2 ~= compressed[0..$ / 2];
    contents2 ~= compressed[$ / 2..$];

    ubyte[] decompressed;
    auto uncompressor = new Decompressor();
    foreach (src; contents2)
        decompressed ~= uncompressor.decompress(src);

    std.stdio.writeln(original == decompressed);
}
