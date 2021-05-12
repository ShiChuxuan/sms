package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Goods;
import com.bjpowernode.crm.workbench.domain.GoodsRemark;

import java.util.List;
import java.util.Map;

public interface GoodsService {
    Boolean addGood(Goods goods);

    PaginationVO<Goods> pageList(Map<String, Object> map);

    boolean deleteGood(String[] ids);

    Goods getGoodById(String id);

    boolean updateGood(Goods good);

    Goods getDetail(String id);

    Map<String, Object> updateGoodInDetail(Goods good);

    List<GoodsRemark> showRemarkList(String goodId);

    boolean deleteRemark(String id);

    Map updateRemark(GoodsRemark goodsRemark);

    Map addRemark(GoodsRemark goodsRemark);

    List<Goods> getGoodListByOrderId(String orderId);

    List<Goods> getGoodListByNameAndNotByOrderId(String name, String orderId);

    List<Goods> getGoodByName(String name);
}
