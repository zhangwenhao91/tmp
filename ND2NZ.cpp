    __aicore__ inline void ND2NZ(const LocalTensor<half>& dst, const GlobalTensor<half>& src, const uint16_t height,
        const uint16_t width)
    {
        DataCopyParams dataCopyParams;
        dataCopyParams.blockCount = 32;                  // 32个数据片段
        dataCopyParams.blockLen = 1;                     // 每个数据片段为1 * 32B
        dataCopyParams.srcStride = 1;                    // 源数据片段（头与尾）间隔为1 * 32B
        dataCopyParams.dstStride = 0;                    // 目的数据片段（头与尾）间隔为0 * 32B

        for (int i = 0; i < 2; ++i) {
            int srcOffset = i * 16;
            int dstOffset = i * 16* 32;
            DataCopy(dst[dstOffset], src[srcOffset], dataCopyParams);
        }
    }
