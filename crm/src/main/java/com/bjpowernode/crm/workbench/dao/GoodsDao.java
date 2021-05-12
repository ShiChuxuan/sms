package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Goods;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface GoodsDao {
    int addGood(Goods goods);

    Goods isExisted(@Param(value = "sid") String sid,@Param(value = "name") String name);

    List<Goods> pageList(Map<String, Object> map);

    int getTotalCondition(Map<String, Object> map);

    int deleteGood(String[] ids);


    Goods selectGoodById(String id);

    int updateGood(Goods good);

    Goods getDetail(String id);

    List<Goods> getGoodListByOrderId(String orderId);

    List<Goods> getGoodListByNameAndNotByOrderId(@Param(value = "name") String name,@Param(value = "orderId") String orderId);

    List<Goods> getGoodListByCustomerId(String customerId);

    List<Goods> getGoodListByNameAndNotByCustomerId(@Param(value = "customerId") String customerId,@Param(value = "name") String name);

    List<Goods> getGoodByName(String name);

    List<Goods> showGoodList(String id);

    int updateGoodAmount(Goods goods);
}
