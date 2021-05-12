package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
    @Resource
    private CustomerGoodsRelationDao customerGoodsRelationDao;
    @Resource
    private TranDao tranDao;
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private TranRemarkDao tranRemarkDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private GoodsDao goodsDao;

    @Override
    @Transactional
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        PaginationVO<Customer> vo = new PaginationVO<>();
        List<Customer> customerList = customerDao.pageList(map);
        int count  = customerDao.getCount(map);
        vo.setDataList(customerList);
        vo.setTotal(count);
        return vo;
    }

    @Override
    @Transactional
    public boolean addCustomer(Customer customer) {
        boolean flag = false;
        int count = customerDao.addCustomer(customer);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Customer getDetail(String id) {
        Customer customer = customerDao.getDetail(id);
        return customer;
    }

    @Override
    @Transactional
    public boolean updateCustomer(Customer customer) {
         boolean flag = false;
         int count = customerDao.updateCustomer(customer);
         if(count==1){
             flag = true;
         }
        return flag;
    }

    @Override
    @Transactional
    public boolean deleteCustomer(String[] id) {
        boolean flag = false;
        //先查询有多少条备注、删除备注
        int count = customerRemarkDao.getCountByCid(id);
        int count2 =  customerRemarkDao.deleteByCid(id);
        if(count!=count2){
            return flag;
        }
        //先查询有多少个关联的商品,删除关联的商品
        int count3 = customerGoodsRelationDao.getCountCid(id);
        int count4 = customerGoodsRelationDao.deleteByCid(id);
        if(count3!=count4){
            return flag;
        }

        //删除交易、删除交易历史、删除交易备注
        List<String> tid = tranDao.getTidByCid(id);//相关交易的id
        if(tid.size()!=0){
            //删除交易备注

            int count5 =  tranRemarkDao.getCountByTid(tid);
            int count6 =  tranRemarkDao.deleteByTid(tid) ;
            if(count5!=count6){
                return flag;
            }

            //删除交易历史
            int count7 =  tranHistoryDao.getCountByTid(tid);
            int count8 =  tranHistoryDao.deleteByTid(tid) ;
            if(count7!=count8){
                return flag;
            }

            //删除交易
            int count9 = tranDao.getCountByCid(id);
            int count10 = tranDao.deleteTranByCid(id);
            if(count9!=count10){
                return flag;
            }
        }


        //删除联系人、删除联系人备注

        List<String> contactsId = contactsDao.getContactIdByCid(id);
        if(contactsId.size()!=0){
            //删除联系人备注
            int count11 = contactsRemarkDao.getCountByContactId(contactsId);
            int count12 = contactsRemarkDao.deleteByContactId(contactsId);
            if(count11!=count12){
                return flag;
            }
            //删除联系人
            int count13 = contactsDao.getContactByCid(id);
            int count14 = contactsDao.deleteContactByCid(id);
            if(count13!=count14){
                return flag;
            }
        }

        //开始删除客户
        int countX = customerDao.deleteCustomer(id);
        if(countX!=id.length){
            return flag;
        }
        flag = true;
        return flag;
    }

    @Override
    public Customer getCustomerById(String id) {
        Customer customer = customerDao.getCustomerById(id);
        return customer;
    }

    @Override
    public List<CustomerRemark> showRemarkList(String customerId) {
        List<CustomerRemark> customerRemarkList = customerRemarkDao.showRemarkList(customerId);
        return customerRemarkList;
    }

    @Override
    @Transactional
    public Map addRemark(CustomerRemark customerRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = customerRemarkDao.addRemark(customerRemark);
        if(count == 1 ){
            flag = true;
            map.put("remark",customerRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count  = customerRemarkDao.deleteRemark(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Map updateRemark(CustomerRemark customerRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = customerRemarkDao.updateRemark(customerRemark);
        customerRemark = customerRemarkDao.selectRemarkById(customerRemark.getId());
        if(count == 1 ){
            flag = true;
            map.put("remark",customerRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public List<Tran> showTranList(String customerId) {
        List<Tran> tranList = tranDao.showTranList(customerId);
        return tranList;
    }

    @Override
    @Transactional
    public boolean deleteTran(String id) {
        boolean flag = false;
        List<String> tid = new ArrayList<>();
        tid.add(0,id);
        //删除交易备注
        tranRemarkDao.deleteByTid(tid);
        //删除交易历史
        tranHistoryDao.deleteByTid(tid);
        //删除交易
        int count = tranDao.deleteTran(id);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    public List<Contacts> showContactList(String customerId) {
        List<Contacts> contactsList= contactsDao.showContactList(customerId);
        return contactsList;
    }

    @Override
    @Transactional
    public boolean deleteContact(String id) {
        boolean flag = false;
        List<String> ContactsId = new ArrayList<>();
        ContactsId.add(id);
        //删除联系人备注
        int count1 = contactsRemarkDao.getCountByContactId(ContactsId);
        int count2 =contactsRemarkDao.deleteByContactId(ContactsId);
        if(count1!=count2){
            return flag;
        }
        //删除联系人
        int count = contactsDao.deleteContact(id);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public boolean addContact(Contacts contacts) {
        boolean flag = false;
        int count = contactsDao.addContact(contacts);
        if(count==1){
            flag=true;
        }

        return flag;
    }

    @Override
    public List<Goods> getGoodListByCustomerId(String customerId) {
        List<Goods> goodsList = goodsDao.getGoodListByCustomerId(customerId);
        return goodsList;
    }

    @Override
    @Transactional
    public boolean unbund(String id) {
        boolean flag = false;
        int count = customerGoodsRelationDao.unbund(id);
        if(count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public List<Goods> getGoodListByNameAndNotByCustomerId(String customerId,String name) {
        List<Goods> goodsList = goodsDao.getGoodListByNameAndNotByCustomerId(customerId,name);
        return goodsList;
    }

    @Override
    public boolean relate(String customerId, String[] id) {
        boolean flag = false;
        List<CustomerGoodsRelation> goodsRelations = new LinkedList<>();
        for (String id1:id){
            CustomerGoodsRelation customerGoodsRelation = new CustomerGoodsRelation();
            customerGoodsRelation.setId(UUIDUtil.getUUID());
            customerGoodsRelation.setCustomerId(customerId);
            customerGoodsRelation.setGoodId(id1);
            goodsRelations.add(customerGoodsRelation);
        }
        int count = customerGoodsRelationDao.addRelation2(goodsRelations);
        if(count==id.length){
            flag = true;
        }
        return flag;

    }
}
