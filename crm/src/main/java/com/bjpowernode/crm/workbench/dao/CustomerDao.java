package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {
    Customer isExist(String company);

    int addCustomer(Customer customer);

    List<Customer> pageList(Map<String, Object> map);

    int getCount(Map<String, Object> map);

    Customer getDetail(String id);

    int updateCustomer(Customer customer);

    int deleteCustomer(String[] id);

    Customer getCustomerById(String id);

    List<String> getCustomerName(String name);
}
