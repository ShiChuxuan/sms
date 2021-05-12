package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.OrderGoodsRelation;

import java.util.List;

public interface OrderGoodsRelationDao {
    int unbund(String id);

    int relate(List<OrderGoodsRelation> orderGoodsRelations);

    List<String> getGoodIds(String orderId);

    int deleteByOrderId(String orderId);
}
