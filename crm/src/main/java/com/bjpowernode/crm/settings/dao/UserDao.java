package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface UserDao {
    public abstract User login(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);

    int resetPwd(@Param(value = "id")String id,@Param(value = "newPwd") String newPwd);

    List<User> getUserList();

    List<User> pageList(Map map);

    int getCount(Map map);

    int delete(String[] id);

    int add(User user);

    User getDetail(String id);

    int edit(User user);
}
