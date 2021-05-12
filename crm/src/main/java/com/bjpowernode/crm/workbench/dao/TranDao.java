package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int addTran(Tran tran);

    List<Tran> showTranList(String customerId);

    int deleteTran(String  id);

    List<String> getTidByCid(String[] id);

    int getCountByCid(String[] id);

    int deleteTranByCid(String[] id);

    List<Tran> pageList(Map<String, Object> map);

    int getCount(Map<String, Object> map);

    Tran getUserListAndTran(String id);

    int updateTran(Tran tran);

    int deleteTrans(String[] id);

    Tran getDetail(String id);

    int changeStage(Tran tran);
}
