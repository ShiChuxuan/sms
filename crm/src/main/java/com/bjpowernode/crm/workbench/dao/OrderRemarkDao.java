package com.bjpowernode.crm.workbench.dao;


import com.bjpowernode.crm.workbench.domain.OrderRemark;

import java.util.List;

public interface OrderRemarkDao {

     int getCountByCid(String[] ids);

     int deleteByCid(String[] ids);


    List<OrderRemark> showRemarkList(String orderId);


    int deleteRemark(String id);

    int deleteRemark2(String orderId);

    int addRemark(OrderRemark orderRemark);

    int updateRemark(OrderRemark orderRemark);

    OrderRemark selectRemarkById(String id);

}
