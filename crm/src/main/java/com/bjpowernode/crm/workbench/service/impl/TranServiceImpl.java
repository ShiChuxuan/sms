package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {
    @Resource
    private TranDao tranDao;
    @Resource
    private TranRemarkDao tranRemarkDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private TranGoodsRelationDao tranGoodsRelationDao;
    @Resource
    private GoodsDao goodsDao;

    @Override
    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        PaginationVO<Tran> vo = new PaginationVO<>();
        List<Tran> tranList = tranDao.pageList(map);
        int total = tranDao.getCount(map);
        vo.setTotal(total);
        vo.setDataList(tranList);
        return vo;
    }

    @Override
    @Transactional
    public boolean addTran(Tran tran) {
        boolean flag = false;
        //查询客户是否存在
        Customer customer = customerDao.isExist(tran.getCustomerId());
        if(customer==null){
            //创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(tran.getCustomerId());
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());

            int count1 = customerDao.addCustomer(customer);
            if(count1 != 1){
                return flag;
            }
        }
        //创建交易
        tran.setCustomerId(customer.getId());
        int count2 = tranDao.addTran(tran);
        if(count2 != 1){
            return flag;
        }
        //创建交易历史
        TranHistory history = new TranHistory();
        history.setId(UUIDUtil.getUUID());
        history.setStage(tran.getStage());
        history.setExpectedDate(tran.getExpectedDate());
        history.setCreateTime(tran.getCreateTime());
        history.setCreateBy(tran.getCreateBy());
        history.setTranId(tran.getId());
        int count3 = tranHistoryDao.addTranHistory(history);
        if(count3 != 1){
            return flag;
        }
        flag = true;
        return flag;
    }

    @Override
    public Tran getUserListAndTran(String id) {
        Tran tran = tranDao.getUserListAndTran(id);
        return tran;
    }

    @Override
    @Transactional
    public boolean updateTran(Tran tran) {
        boolean flag = false;

        //查询客户是否存在
        Customer customer = customerDao.isExist(tran.getCustomerId());
        if(customer==null){
            //创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(tran.getCustomerId());
            customer.setOwner(tran.getOwner());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());

            int count = customerDao.addCustomer(customer);
            if(count != 1){
                return flag;
            }
        }


        //更新交易
        tran.setCustomerId(customer.getId());
        int count  = tranDao.updateTran(tran);
        if(count!=1){
            return flag;
        }
        //添加一条历史记录
        TranHistory history = new TranHistory();
        history.setTranId(tran.getId());
        history.setId(UUIDUtil.getUUID());
        history.setExpectedDate(tran.getExpectedDate());
        history.setCreateBy(tran.getEditBy());
        history.setCreateTime(tran.getEditTime());
        history.setPossibility(tran.getPossibility());
        history.setMoney(tran.getMoney());
        history.setStage(tran.getStage());
        int count2 = tranHistoryDao.addTranHistory(history);
        if(count2!=1){
            return flag;
        }
        flag = true;
        return flag;
    }

    @Override
    @Transactional
    public boolean deleteTran(String[] id) {
        boolean flag = false;
        List<String> tid = new ArrayList<>();
        int i = 0;
        for(String id1:id){
            tid.add(i,id1);
        }

        //删除交易备注
        tranRemarkDao.deleteByTid(tid);
        //删除交易历史
        tranHistoryDao.deleteByTid(tid);
        //删除交易
        int count = tranDao.deleteTrans(id);
        if(count==id.length){
            flag = true;
        }
        return flag;
    }

    @Override
    public Tran getDetail(String id) {

        Tran tran = tranDao.getDetail(id);
        return tran;
    }

    @Override
    public List<Goods> showGoodList(String id) {
        List<Goods> goodsList  = goodsDao.showGoodList(id);
        return goodsList;
    }

    @Override
    public Boolean unbund(String id) {
        boolean flag = false;
        int count =  tranGoodsRelationDao.unbund(id);
        if(count==1){
            flag = true;
        }

        return flag;
    }

    @Override
    @Transactional
    public boolean orderGood(String tranId,String goodId,String amount) {
        boolean flag = false;
        int amountInt1 = Integer.parseInt(amount);
        //查询是否已经订购过该商品
        TranGoodsRelation tranGoodsRelation =tranGoodsRelationDao.isExist(tranId,goodId);
        if(tranGoodsRelation == null){
            //创建联系
            tranGoodsRelation = new TranGoodsRelation();
            tranGoodsRelation.setId(UUIDUtil.getUUID());
            tranGoodsRelation.setAmount(amount);
            tranGoodsRelation.setGoodId(goodId);
            tranGoodsRelation.setTranId(tranId);
            int count  = tranGoodsRelationDao.orderGood(tranGoodsRelation);
            if(count !=1){
                return flag;
            }
        }else{
            int amountInt = amountInt1 + Integer.parseInt(tranGoodsRelation.getAmount());
            tranGoodsRelation.setAmount(String.valueOf(amountInt));
            int count2 =tranGoodsRelationDao.updateRelation(tranGoodsRelation);
            if(count2 !=1){
                return flag;
            }
        }

        //更新商品的库存
        Goods goods = goodsDao.getDetail(tranGoodsRelation.getGoodId());
        int amountInt2 = Integer.parseInt(goods.getAmount());
        goods.setAmount(String.valueOf(amountInt2-amountInt1));
        int count3 = goodsDao.updateGoodAmount(goods);
        if(count3!=1){
            return flag;
        }

        //更行交易的金额

        flag = true;
        return flag;
    }

    @Override
    public List<TranRemark> showRemarkList(String tranId) {
        List<TranRemark> tranRemarkList = tranRemarkDao.showRemarkList(tranId);
        return tranRemarkList;
    }

    @Override
    @Transactional
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count  = tranRemarkDao.deleteRemark(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Map updateRemark(TranRemark tranRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = tranRemarkDao.updateRemark(tranRemark);
        tranRemark = tranRemarkDao.selectRemarkById(tranRemark.getId());
        if(count == 1 ){
            flag = true;
            map.put("remark",tranRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public Map addRemark(TranRemark tranRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = tranRemarkDao.addRemark(tranRemark);
        if(count == 1 ){
            flag = true;
            map.put("remark",tranRemark);
        }
        map.put("success",flag);
        return map;
    }


    @Override
    public List<TranHistory> showTranHistoryList(String tranId) {
        List<TranHistory> tranHistoryList = tranHistoryDao.showTranHistoryList(tranId);
        return tranHistoryList;
    }

    @Override
    @Transactional
    public boolean changeStage(Tran tran) {
        boolean flag = false;
        //先更新交易
        int count1 = tranDao.changeStage(tran);
        if(count1!=1){
            return flag;
        }
        //增加一条交易历史
        TranHistory history = new TranHistory();
        history.setId(UUIDUtil.getUUID());
        history.setMoney(tran.getMoney());
        history.setExpectedDate(tran.getExpectedDate());
        history.setCreateTime(tran.getEditTime());
        history.setCreateBy(tran.getEditBy());
        history.setTranId(tran.getId());
        history.setStage(tran.getStage());
        int count2 =tranHistoryDao.addTranHistory(history);
        if(count2!=1){
            return flag;
        }
        flag = true;
        return flag;
    }
}
