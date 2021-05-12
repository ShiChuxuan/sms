package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    int getCountByTid(List<String> tid);

    int deleteByTid(List<String> tid);

    List<TranRemark> showRemarkList(String tranId);

    int deleteRemark(String id);

    int updateRemark(TranRemark tranRemark);

    TranRemark selectRemarkById(String id);

    int addRemark(TranRemark tranRemark);
}
