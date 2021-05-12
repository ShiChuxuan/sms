package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    int addRemark(CustomerRemark customerRemark);


    int getCountByCid(String[] id);

    int deleteByCid(String[] id);

    List<CustomerRemark> showRemarkList(String customerId);

    int deleteRemark(String id);

    int updateRemark(CustomerRemark customerRemark);

    CustomerRemark selectRemarkById(String id);
}
