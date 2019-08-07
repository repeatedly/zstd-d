module zstd.c.zstd;

extern (C):
@trusted:

alias ZSTD_CCtx_s ZSTD_CCtx;
alias ZSTD_DCtx_s ZSTD_DCtx;
alias ZSTD_CDict_s ZSTD_CDict;
alias ZSTD_DDict_s ZSTD_DDict;
alias ZSTD_inBuffer_s ZSTD_inBuffer;
alias ZSTD_outBuffer_s ZSTD_outBuffer;
alias ZSTD_CStream_s ZSTD_CStream;
alias ZSTD_DStream_s ZSTD_DStream;

struct ZSTD_inBuffer_s
{
    const(void)* src;
    size_t size;
    size_t pos;
}

struct ZSTD_outBuffer_s
{
    void* dst;
    size_t size;
    size_t pos;
}

struct ZSTD_DStream_s;


struct ZSTD_CCtx_s;


struct ZSTD_CStream_s;


struct ZSTD_DDict_s;


struct ZSTD_DCtx_s;


struct ZSTD_CDict_s;


uint ZSTD_versionNumber ();
size_t ZSTD_compress (void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, int compressionLevel);
size_t ZSTD_getDecompressedSize (const(void)* src, size_t srcSize);
size_t ZSTD_decompress (void* dst, size_t dstCapacity, const(void)* src, size_t compressedSize);
int ZSTD_maxCLevel ();
size_t ZSTD_compressBound (size_t srcSize);
uint ZSTD_isError (size_t code);
const(char)* ZSTD_getErrorName (size_t code);
ZSTD_CCtx* ZSTD_createCCtx ();
size_t ZSTD_freeCCtx (ZSTD_CCtx* cctx);
size_t ZSTD_compressCCtx (ZSTD_CCtx* ctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, int compressionLevel);
ZSTD_DCtx* ZSTD_createDCtx ();
size_t ZSTD_freeDCtx (ZSTD_DCtx* dctx);
size_t ZSTD_decompressDCtx (ZSTD_DCtx* ctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize);
size_t ZSTD_compress_usingDict (ZSTD_CCtx* ctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, const(void)* dict, size_t dictSize, int compressionLevel);
size_t ZSTD_decompress_usingDict (ZSTD_DCtx* dctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, const(void)* dict, size_t dictSize);
ZSTD_CDict* ZSTD_createCDict (const(void)* dict, size_t dictSize, int compressionLevel);
size_t ZSTD_freeCDict (ZSTD_CDict* CDict);
size_t ZSTD_compress_usingCDict (ZSTD_CCtx* cctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, const(ZSTD_CDict)* cdict);
ZSTD_DDict* ZSTD_createDDict (const(void)* dict, size_t dictSize);
size_t ZSTD_freeDDict (ZSTD_DDict* ddict);
size_t ZSTD_decompress_usingDDict (ZSTD_DCtx* dctx, void* dst, size_t dstCapacity, const(void)* src, size_t srcSize, const(ZSTD_DDict)* ddict);
ZSTD_CStream* ZSTD_createCStream ();
size_t ZSTD_freeCStream (ZSTD_CStream* zcs);
size_t ZSTD_CStreamInSize ();
size_t ZSTD_CStreamOutSize ();
size_t ZSTD_initCStream (ZSTD_CStream* zcs, int compressionLevel);
size_t ZSTD_compressStream (ZSTD_CStream* zcs, ZSTD_outBuffer* output, ZSTD_inBuffer* input);
size_t ZSTD_flushStream (ZSTD_CStream* zcs, ZSTD_outBuffer* output);
size_t ZSTD_endStream (ZSTD_CStream* zcs, ZSTD_outBuffer* output);
ZSTD_DStream* ZSTD_createDStream ();
size_t ZSTD_freeDStream (ZSTD_DStream* zds);
size_t ZSTD_DStreamInSize ();
size_t ZSTD_DStreamOutSize ();
size_t ZSTD_initDStream (ZSTD_DStream* zds);
size_t ZSTD_decompressStream (ZSTD_DStream* zds, ZSTD_outBuffer* output, ZSTD_inBuffer* input);
