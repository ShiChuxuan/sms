package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Order;
import com.bjpowernode.crm.workbench.domain.OrderRemark;

import java.util.List;
import java.util.Map;

public interface OrderDao {
    List<Order> pageList(Map<String, Object> map);

    int getTotalCondition(Map<String, Object> map);

    int addOrder(Order order);

    Order getOrderById(String id);

    int updateOrder(Order order);

    int deleteOrder(String[] id);

    Order getDetail(String id);


}
