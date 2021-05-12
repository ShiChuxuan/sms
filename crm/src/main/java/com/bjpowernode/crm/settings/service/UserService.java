package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login (String loginAct,String loginPwd,String ip);

    boolean resetPwd(String id,String newPwd);

    List<User> getUserList();

    PaginationVO<User> pageList(Map map);

    boolean delete(String[] id);

    boolean add(User user);

    User getDetail(String id);

    Map<String, Object> edit(User user);
}
