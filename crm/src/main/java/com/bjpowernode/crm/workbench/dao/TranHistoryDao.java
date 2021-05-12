package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    int addTranHistory(TranHistory tranHistory);

    int getCountByTid(List<String> tid);

    int deleteByTid(List<String> tid);

    List<TranHistory> showTranHistoryList(String tranId);
}
