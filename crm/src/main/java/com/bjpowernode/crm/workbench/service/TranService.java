package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


public interface TranService {
    PaginationVO<Tran> pageList(Map<String, Object> map);

    boolean addTran(Tran tran);

    Tran getUserListAndTran(String id);

    boolean updateTran(Tran tran);

    boolean deleteTran(String[] id);

    Tran getDetail(String id);

    List<Goods> showGoodList(String id);

    Boolean unbund(String id);

    boolean orderGood(String tranId,String goodId,String amount);

    List<TranRemark> showRemarkList(String tranId);

    boolean deleteRemark(String id);

    Map updateRemark(TranRemark tranRemark);

    Map addRemark(TranRemark tranRemark);

    List<TranHistory> showTranHistoryList(String tranId);

    boolean changeStage(Tran tran);
}
