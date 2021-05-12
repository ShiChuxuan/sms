package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.GoodsDao;
import com.bjpowernode.crm.workbench.dao.GoodsRemarkDao;
import com.bjpowernode.crm.workbench.domain.Goods;
import com.bjpowernode.crm.workbench.domain.GoodsRemark;
import com.bjpowernode.crm.workbench.service.GoodsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.rmi.MarshalledObject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GoodsServiceImpl implements GoodsService {
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private GoodsRemarkDao goodsRemarkDao;



    @Override
    @Transactional
    public Boolean addGood(Goods goods) {

        int count = goodsDao.addGood(goods);
            if(count == 1){
                return true;
            }


        return false;
    }

    @Override
    @Transactional
    public PaginationVO<Goods> pageList(Map<String, Object> map) {
        PaginationVO<Goods> vo =new PaginationVO<>();
        //获得dataList
        List<Goods> goods = goodsDao.pageList(map);
        //获得total
        int total = goodsDao.getTotalCondition(map);
        //放入数据
        vo.setTotal(total);
        vo.setDataList(goods);

        return vo;
    }

    @Override
    @Transactional
    public boolean deleteGood(String[] ids) {

            //先查询有多少条备注
            int count1 = goodsRemarkDao.findAllRemarksCount(ids);
            //删除备注
            int count2 = goodsRemarkDao.deleteRemarksById(ids);

            if(count1!=count2){
                return false;
            }
            //删除商品
            int count3 = goodsDao.deleteGood(ids);
            if(ids.length!=count3){
                return false;
            }

            return true;
    }

    @Override
    @Transactional
    public Goods getGoodById(String id) {
        return goodsDao.selectGoodById(id);
    }

    @Override
    @Transactional
    public boolean updateGood(Goods good) {
        boolean flag  = false;

            int result = goodsDao.updateGood(good);
            if(result==1){
                flag = true;
            }

        return flag;
    }

    @Override
    @Transactional
    public Goods getDetail(String id) {
        Goods goods = goodsDao.getDetail(id);
        return goods;
    }

    @Override
    @Transactional
    public Map<String, Object> updateGoodInDetail(Goods good) {
        boolean flag  = false;
        Map map = new HashMap();

            int result = goodsDao.updateGood(good);
            if(result==1){
                flag = true;
                good = goodsDao.getDetail(good.getId());
                map.put("good",good);
            }

        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public List<GoodsRemark> showRemarkList(String goodId) {
        List<GoodsRemark> goodsRemarkList = goodsRemarkDao.showRemarkList(goodId);
        return goodsRemarkList;
    }

    @Override
    @Transactional
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count  = goodsRemarkDao.deleteRemark(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public Map updateRemark(GoodsRemark goodsRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = goodsRemarkDao.updateRemark(goodsRemark);
        goodsRemark = goodsRemarkDao.selectRemarkById(goodsRemark.getId());
        if(count == 1 ){
            flag = true;
            map.put("remark",goodsRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public Map addRemark(GoodsRemark goodsRemark) {
        boolean flag = false;
        Map map = new HashMap();
        int count = goodsRemarkDao.addRemark(goodsRemark);
        if(count == 1 ){
            flag = true;
            map.put("remark",goodsRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    @Transactional
    public List<Goods> getGoodListByOrderId(String orderId) {
        List<Goods> goodsList = goodsDao.getGoodListByOrderId(orderId);
        return goodsList;
    }

    @Override
    public List<Goods> getGoodListByNameAndNotByOrderId(String name, String orderId) {
        List<Goods> goodsList = goodsDao.getGoodListByNameAndNotByOrderId(name,orderId);

        return goodsList;
    }

    @Override
    public List<Goods> getGoodByName(String name) {
        List<Goods> goods = goodsDao.getGoodByName(name);
        return goods;
    }


}
