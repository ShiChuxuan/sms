package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactsDao {
    int addContact(Contacts contact);

    List<Contacts> showContactList(String customerId);

    int deleteContact(String id);

    List<String> getContactIdByCid(String[] id);

    int getContactByCid(String[] id);

    int deleteContactByCid(String[] id);

    List<Contacts> pageList(Map<String, Object> map);

    int getCount(Map<String, Object> map);

    Contacts getContactById(String id);

    int updateContacts(Contacts contacts);

    int deleteContactById(String[] id);

    Contacts getDetail(String id);

    List<Contacts> getAllContacts();

    List<Contacts> searchContacts(String name);
}
