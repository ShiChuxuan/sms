package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

public interface OrderService {
    PaginationVO<Order> pageList(Map<String, Object> map);

    boolean addOrder(Order order);

    Order getOrderById(String id);

    boolean updateOrder(Order order);

    boolean deleteOrder(String[] id);

    Order getDetail(String id);

    Map<String, Object> updateOrderInDetail(Order order);

    List<OrderRemark> showRemarkList(String orderId);

    boolean deleteRemark(String id);

    Map addRemark(OrderRemark orderRemark);


    Map updateRemark(OrderRemark orderRemark);

    boolean unbund(String id);


    boolean relate(String[] id, String orderId);

    boolean convert(String orderId, Tran tran, String createBy);
}
