package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranGoodsRelation;
import org.apache.ibatis.annotations.Param;

public interface TranGoodsRelationDao {


    int unbund(String id);

    TranGoodsRelation isExist(@Param(value = "tranId") String tranId,@Param(value = "goodId") String goodId);

    int orderGood(TranGoodsRelation tranGoodsRelation);

    int updateRelation(TranGoodsRelation tranGoodsRelation);
}
