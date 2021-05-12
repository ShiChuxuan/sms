package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Goods;
import com.bjpowernode.crm.workbench.domain.GoodsRemark;

import java.util.List;

public interface GoodsRemarkDao {
    int findAllRemarksCount(String[] ids);

    int deleteRemarksById(String[] ids);

    List<GoodsRemark> showRemarkList(String goodId);

    int deleteRemark(String id);

    int updateRemark(GoodsRemark goodsRemark);

    GoodsRemark selectRemarkById(String id);

    int addRemark(GoodsRemark goodsRemark);


}
