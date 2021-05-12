package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    PaginationVO<Customer> pageList(Map<String, Object> map);

    boolean addCustomer(Customer customer);

    Customer getDetail(String id);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomer(String[] id);

    Customer getCustomerById(String id);

    List<CustomerRemark> showRemarkList(String customerId);

    Map addRemark(CustomerRemark customerRemark);

    boolean deleteRemark(String id);

    Map updateRemark(CustomerRemark customerRemark);

    List<Tran> showTranList(String customerId);

    boolean deleteTran(String id);

    List<Contacts> showContactList(String customerId);

    boolean deleteContact(String id);

    boolean addContact(Contacts contacts);

    List<Goods> getGoodListByCustomerId(String customerId);

    boolean unbund(String id);

    List<Goods> getGoodListByNameAndNotByCustomerId(String customerId,String name);

    boolean relate(String customerId, String[] id);
}
