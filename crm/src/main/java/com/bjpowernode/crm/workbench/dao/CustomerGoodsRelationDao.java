package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerGoodsRelation;

import java.util.List;

public interface CustomerGoodsRelationDao {
    int addRelation(CustomerGoodsRelation customerGoodsRelation);

    int getCountCid(String[] id);

    int deleteByCid(String[] id);

    int unbund(String id);

    int addRelation2(List<CustomerGoodsRelation> goodsRelations);
}
