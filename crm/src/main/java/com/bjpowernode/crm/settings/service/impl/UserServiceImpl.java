package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.MD5Util;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    //引用类型的自动注入@Autowired,@Resource
    @Resource
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd, String ip) {
        loginPwd = MD5Util.getMD5(loginPwd);    //加密密码
        User user = userDao.login(loginAct,loginPwd);

//---------------------------------------------------------------------------
        if(user==null){
            //判断账号是否为空
            throw new LoginException("账号未注册或密码错误");
        }
//---------------------------------------------------------------------------
        String expireTime = user.getExpireTime();       //有效时间
        String currentTime = DateTimeUtil.getSysTime(); //系统时间
        if(expireTime.compareTo(currentTime)>=0){       //根据数据字典比较
            //账户在有效期内
        }else{
            throw new LoginException("账户已过期");
        }
//---------------------------------------------------------------------------
        //判断是否锁定
        String lockState = user.getLockState();
        if("1".equals(lockState)){
            //未被锁定
        }else{
            throw new LoginException("账户已被锁定");
        }
//---------------------------------------------------------------------------
        //判断ip地址是否合法
        String allowIps = user.getAllowIps(); //允许访问的ip
        if(allowIps.contains(ip)){
            //ip合法
        }else{
            throw new LoginException("此ip不允许登录");
        }
//---------------------------------------------------------------------------

        return user;
    }

    @Override
    @Transactional
    public boolean resetPwd(String id, String newPwd) {
        boolean flag = false;
        int result = userDao.resetPwd(id,newPwd);
        if(result==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();
        return userList;
    }

    @Override
    public PaginationVO<User> pageList(Map map) {
        PaginationVO<User> vo = new PaginationVO<>();
        List<User> userList = userDao.pageList(map);
        int total = userDao.getCount(map);
        vo.setDataList(userList);
        vo.setTotal(total);

        return vo;
    }

    @Override
    @Transactional
    public boolean delete(String[] id) {
        boolean flag = false;
        int count  = userDao.delete(id);
        if(count!=id.length){
            return flag;
        }
        flag = true;
        return flag;
    }

    @Override
    @Transactional
    public boolean add(User user) {
        boolean flag = false;
        int count = userDao.add(user);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    public User getDetail(String id) {
        User user = userDao.getDetail(id);
        return user;
    }

    @Override
    @Transactional
    public Map<String, Object> edit(User user) {
        Map<String,Object> map = new HashMap<>();
        boolean flag = false;
        int count = userDao.edit(user);
        if(count==1){
            flag = true;
            User user1 = userDao.getDetail(user.getId());
            map.put("user",user1);
        }
        map.put("success",flag);
        return map;
    }


}
