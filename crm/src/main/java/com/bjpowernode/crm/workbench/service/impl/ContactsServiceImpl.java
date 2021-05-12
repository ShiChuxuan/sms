package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.dao.ContactsRemarkDao;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private UserDao userDao;



    @Override
    public PaginationVO<Contacts> pageList(Map<String, Object> map) {
        PaginationVO<Contacts> vo = new PaginationVO<>();

        List<Contacts> contactsList = contactsDao.pageList(map);
        int count = contactsDao.getCount(map);

        vo.setDataList(contactsList);
        vo.setTotal(count);


        return vo;
    }

    @Override
    public List<String> getCustomerName(String name) {
        List<String> nameList = customerDao.getCustomerName(name);
        return nameList;
    }

    @Override
    @Transactional
    public boolean addContacts(Contacts contacts) {
        boolean flag = false;
        Customer customer = customerDao.isExist(contacts.getCustomerId());
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());//id
            customer.setOwner(contacts.getOwner());//owner
            customer.setName(contacts.getCustomerId());//name
            customer.setCreateBy(contacts.getCreateBy());//createBy
            customer.setCreateTime(contacts.getCreateTime());//createTime
            customer.setContactSummary(contacts.getContactSummary());//contactSummary
            customer.setNextContactTime(contacts.getNextContactTime());//nextContactTime
            customer.setDescription(contacts.getDescription());//description
            customer.setAddress(contacts.getAddress());//address

            int count = customerDao.addCustomer(customer);
            if(count!=1){
                return flag;
            }

        }
        contacts.setCustomerId(customer.getId());
        int count2 = contactsDao.addContact(contacts);
        if(count2==1){
            flag = true;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        Map<String,Object>map = new HashMap<>();
        List<User> userList = userDao.getUserList();
        Contacts contacts = contactsDao.getContactById(id);
        map.put("userList",userList);
        map.put("contacts",contacts);
        return map;
    }

    @Override
    @Transactional
    public boolean updateContacts(Contacts contacts) {
        boolean flag = false;
        //判断客户存不存在
        Customer customer = customerDao.isExist(contacts.getCustomerId());
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());//id
            customer.setOwner(contacts.getOwner());//owner
            customer.setName(contacts.getCustomerId());//name
            customer.setCreateBy(contacts.getCreateBy());//createBy
            customer.setCreateTime(contacts.getCreateTime());//createTime
            customer.setContactSummary(contacts.getContactSummary());//contactSummary
            customer.setNextContactTime(contacts.getNextContactTime());//nextContactTime
            customer.setDescription(contacts.getDescription());//description
            customer.setAddress(contacts.getAddress());//address

            int count = customerDao.addCustomer(customer);
            if(count!=1){
                return flag;
            }
        }
        contacts.setCustomerId(customer.getId());
        int count2 = contactsDao.updateContacts(contacts);
        if(count2==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public boolean deleteContact(String[] id) {
        boolean flag = false;
        List<String> ContactsId = new ArrayList<>();
        for(String id1:id){
            ContactsId.add(id1);

        }

         //删除联系人备注
        int count1 = contactsRemarkDao.getCountByContactId(ContactsId);
        int count2 =contactsRemarkDao.deleteByContactId(ContactsId);
        if(count1!=count2){
            return flag;
        }
        //删除联系人
          int count3 = contactsDao.deleteContactById(id);

        if(count3==id.length){
            flag = true;
        }
        return flag;
    }

    @Override
    public Contacts getDetail(String id) {
        Contacts contacts = contactsDao.getDetail(id);
        return contacts;
    }

    @Override
    public List<ContactsRemark> showRemarkList(String contactsId) {
        List<ContactsRemark> contactsRemarks =contactsRemarkDao.showRemarkList(contactsId);
        return contactsRemarks;
    }

    @Override
    @Transactional
    public Map<String, Object> updateRemark(ContactsRemark contactsRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = contactsRemarkDao.updateRemark(contactsRemark);
        contactsRemark = contactsRemarkDao.selectRemarkById(contactsRemark.getId());
        if(count == 1 ){
            flag = true;
            map.put("remark",contactsRemark);
        }
        map.put("success",flag);
        return map;
    }


    @Override
    @Transactional
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count  = contactsRemarkDao.deleteRemark(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Map addRemark(ContactsRemark contactsRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = contactsRemarkDao.addRemark(contactsRemark);
        if(count == 1 ){
            flag = true;
            map.put("remark",contactsRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public List<Contacts> getAllContacts() {
        List<Contacts> contactsList = contactsDao.getAllContacts();
        return contactsList;
    }

    @Override
    public List<Contacts> searchContacts(String name) {
        List<Contacts> contactsList = contactsDao.searchContacts(name);
        return contactsList;
    }


}
