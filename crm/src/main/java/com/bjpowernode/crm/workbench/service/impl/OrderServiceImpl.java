package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.OrderService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Service
public class OrderServiceImpl implements OrderService {
    @Resource
    private OrderDao orderDao;
    @Resource
    private OrderRemarkDao orderRemarkDao;
    @Resource
    private OrderGoodsRelationDao orderGoodsRelationDao;
    //客户相关
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
    @Resource
    private CustomerGoodsRelationDao customerGoodsRelationDao;
    //联系人相关
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    //交易相关
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    @Override
    @Transactional
    public PaginationVO<Order> pageList(Map<String, Object> map) {
        PaginationVO<Order> vo = new PaginationVO<>();
        //订单数据
        List<Order> orderList = orderDao.pageList(map);
        //总条数
        int total = orderDao.getTotalCondition(map);
        vo.setDataList(orderList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    @Transactional
    public boolean addOrder(Order order) {
        boolean flag = false;
        int count = orderDao.addOrder(order);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Order getOrderById(String id) {
        Order order = orderDao.getOrderById(id);

        return order;
    }

    @Override
    @Transactional
    public boolean updateOrder(Order order) {
        boolean flag  = false;

        int result = orderDao.updateOrder(order);
        if(result==1){
            flag = true;
        }

        return flag;
    }

    @Override
    @Transactional
    public boolean deleteOrder(String[] id) {

        //先查询有多少条备注
        int count1 = orderRemarkDao.getCountByCid(id);
        //删除备注
        int count2 = orderRemarkDao.deleteByCid(id);

        if(count1!=count2){
            return false;
        }
        //删除商品
        int count3 = orderDao.deleteOrder(id);
        if(id.length!=count3){
            return false;
        }

        return true;
    }

    @Override
    @Transactional
    public Order getDetail(String id) {
        Order order = orderDao.getDetail(id);

        return order;
    }

    @Override
    @Transactional
    public Map<String, Object> updateOrderInDetail(Order order) {
        boolean flag  = false;
        Map map = new HashMap();

        int result = orderDao.updateOrder(order);
        if(result==1){
            flag = true;
            order = orderDao.getDetail(order.getId());
            map.put("order",order);
        }

        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public List<OrderRemark> showRemarkList(String orderId) {

        List<OrderRemark> orderRemarkList = orderRemarkDao.showRemarkList(orderId);
        return orderRemarkList;
    }

    @Override
    @Transactional
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count  = orderRemarkDao.deleteRemark(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Map addRemark(OrderRemark orderRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = orderRemarkDao.addRemark(orderRemark);
        if(count == 1 ){
            flag = true;
            map.put("remark",orderRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public Map updateRemark(OrderRemark orderRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = orderRemarkDao.updateRemark(orderRemark);
        orderRemark = orderRemarkDao.selectRemarkById(orderRemark.getId());
        if(count == 1 ){
            flag = true;
            map.put("remark",orderRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public boolean unbund(String id) {
        boolean flag = false;
        int count =  orderGoodsRelationDao.unbund(id);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public boolean relate(String[] id, String orderId) {
        int length = id.length;
        List <OrderGoodsRelation> orderGoodsRelations = new LinkedList<>();

        //创建uuid、并封装
        for(int i=0;i<length;i++){
            String uuid = UUIDUtil.getUUID();
            OrderGoodsRelation orderGoodsRelation = new OrderGoodsRelation();
            orderGoodsRelation.setId(uuid);
            orderGoodsRelation.setOrderId(orderId);
            orderGoodsRelation.setGoodId(id[i]);
            orderGoodsRelations.add(orderGoodsRelation);
        }
        //执行
        int count =orderGoodsRelationDao.relate(orderGoodsRelations);
        if(count==length){
            return true;
        }
        return false;
    }

    @Override
    @Transactional
    public boolean convert(String orderId, Tran tran, String createBy) {
        boolean flag = false;
        String createTime = DateTimeUtil.getSysTime();
        Order order = orderDao.getOrderById(orderId);//获得线索详细信息



        /*=======================创建客户=========================*/
        //先查询这个客户是否存在、存在就不创建、不存在创建
        Customer customer = customerDao.isExist(order.getCompany());
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());//id
            customer.setOwner(order.getOwner());//owner
            customer.setName(order.getCompany());//name
            customer.setWebsite(order.getWebsite());//website
            customer.setPhone(order.getPhone());//phone
            customer.setCreateBy(createBy);//createBy
            customer.setCreateTime(createTime);//createTime
            customer.setContactSummary(order.getContactSummary());//contactSummary
            customer.setNextContactTime(order.getNextContactTime());//nextContactTime
            customer.setDescription(order.getDescription());//description
            customer.setAddress(order.getAddress());//address

            int count = customerDao.addCustomer(customer);
            if(count!=1){
                return flag;
            }
        }
        /*=======================创建联系人=========================*/
        Contacts contact = new Contacts();
        contact.setId(UUIDUtil.getUUID());
        contact.setOwner(order.getOwner());
        contact.setSource(order.getSource());
        contact.setCustomerId(customer.getId());//公司id
        contact.setFullname(order.getFullname());
        contact.setAppellation(order.getAppellation());
        contact.setEmail(order.getEmail());
        contact.setMphone(order.getMphone());
        contact.setJob(order.getJob());
        contact.setCreateBy(createBy);
        contact.setCreateTime(createTime);
        contact.setDescription(order.getDescription());
        contact.setContactSummary(order.getContactSummary());
        contact.setNextContactTime(order.getNextContactTime());
        contact.setAddress(order.getAddress());

        int count2 = contactsDao.addContact(contact);
        if(count2!=1){
            return flag;
        }
        /*=======================订单备注转换为客户备注、联系人备注=========================*/
        //先查询所有的备注
        List<OrderRemark> orderRemarkList = orderRemarkDao.showRemarkList(orderId);
        int count3 = 0;
        //转换为联系人备注
        for(OrderRemark orderRemark:orderRemarkList){
            ContactsRemark contactsRemark = new ContactsRemark();
            String noteContent = orderRemark.getNoteContent();//获得备注信息
            //创建联系人备注
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contact.getId());
            //执行创建操作
            contactsRemarkDao.addRemark(contactsRemark);
            count3++;
        }
        if(count3!=orderRemarkList.size()){
            return flag;
        }
        int count4 = 0;
        //转换为客户备注
        for(OrderRemark orderRemark:orderRemarkList){
            CustomerRemark customerRemark = new CustomerRemark();
            String noteContent =  orderRemark.getNoteContent();//获得备注信息
            //创建联系人备注
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            //执行创建操作
            customerRemarkDao.addRemark(customerRemark);
            count4++;
        }
        if(count4!=orderRemarkList.size()){
            return flag;
        }
        /*=======================订单商品关联关系转为客户商品关联关系=========================*/
        List<String> goodIds = orderGoodsRelationDao.getGoodIds(orderId);
        //转换
        int count5 = 0;
        for(String goodId:goodIds){
            CustomerGoodsRelation customerGoodsRelation = new CustomerGoodsRelation();

            customerGoodsRelation.setId(UUIDUtil.getUUID());
            customerGoodsRelation.setGoodId(goodId);
            customerGoodsRelation.setCustomerId(customer.getId());

            customerGoodsRelationDao.addRelation(customerGoodsRelation);
            count5++;
        }
        if(count5!=goodIds.size()){
            return flag;
        }
        /*=======================如果有创建交易需求，创建一条交易=========================*/
        if(tran!=null){
            tran.setCustomerId(customer.getId());
            tran.setOwner(order.getOwner());
            tran.setSource(order.getSource());
            tran.setNextContactTime(order.getNextContactTime());
            tran.setDescription(order.getDescription());
            tran.setContactSummary(order.getContactSummary());
            tran.setContactsId(contact.getId());

            int count6  = tranDao.addTran(tran);
            if(count6!=1){
                return flag;
            }
            //如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(createTime);
            tranHistory.setCreateBy(createBy);
            tranHistory.setTranId(tran.getId());
            int count7 = tranHistoryDao.addTranHistory(tranHistory);
            if(count7!=1){
                return flag;
            }
        }
        /*=======================删除订单备注、删除订单商品关系、删除订单=========================*/
        //删除订单备注
        int count8 = orderRemarkDao.deleteRemark2(orderId);
        if(count8!=orderRemarkList.size()){
            return flag;
        }
        //删除订单商品关系
        int count9 = orderGoodsRelationDao.deleteByOrderId(orderId);
        if(count9!=goodIds.size()){
            return flag;
        }
        //删除订单
        String[]ids = new String[1];
        ids[0] = orderId;
        int count10 = orderDao.deleteOrder(ids);
        if(count10!=1){
            return flag;
        }
        flag = true;
        return flag;
    }


}
