package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {
    int addRemark(ContactsRemark contactsRemark);

    int getCountByContactId(List<String> contactsId);

    int deleteByContactId(List<String> contactsId);

    List<ContactsRemark> showRemarkList(String contactsId);

    int updateRemark(ContactsRemark contactsRemark);

    ContactsRemark selectRemarkById(String id);

    int deleteRemark(String id);
}
