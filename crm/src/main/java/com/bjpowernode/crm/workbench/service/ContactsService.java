package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactsService {


    PaginationVO<Contacts> pageList(Map<String, Object> map);

    List<String> getCustomerName(String name);

    boolean addContacts(Contacts contacts);

    Map<String, Object> getUserListAndContacts(String id);

    boolean updateContacts(Contacts contacts);

    boolean deleteContact(String[] id);

    Contacts getDetail(String id);

    List<ContactsRemark> showRemarkList(String contactsId);

    Map<String, Object> updateRemark(ContactsRemark contactsRemark);

    boolean deleteRemark(String id);

    Map addRemark(ContactsRemark contactsRemark);

    List<Contacts> getAllContacts();

    List<Contacts> searchContacts(String name);
}
