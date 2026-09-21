    __aicore__ inline void NZ2ZZ()
    {
        int srcOffset = 0;
        int dstOffset = 0;
        LocalTensor<half> a1Local = inQueueA1.DeQue<half>();
        LocalTensor<half> a2Local = inQueueA2.AllocTensor<half>();

        LoadData2dParams loadDataParams;
        loadDataParams.repeatTimes = 2;   // 迭代次数为2
        loadDataParams.srcStride = 2;     // 源分形矩阵（头与头）间隔为2 * 512B
        loadDataParams.dstGap = 0;              // 目的分形矩阵（头与头）间隔为0 * 512B
        loadDataParams.ifTranspose = false;     // 对每个分形矩阵进行转置

        // transform nz to zz
        for (int i = 0; i < 2; ++i) {
            LoadData(a2Local[dstOffset], a1Local[srcOffset], loadDataParams);

            srcOffset += 32 / 2 * 16;
            dstOffset += 32 * 16;
        }

        inQueueA2.EnQue<half>(a2Local);
        inQueueA1.FreeTensor(a1Local);
    }
