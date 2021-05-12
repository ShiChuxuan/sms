package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.exception.ResetException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.MD5Util;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping(value = "/settings/user")
public class UserController {
    @Resource
    private UserService userService;

    @RequestMapping(value = "/login.do")
    @ResponseBody
    public Map login(HttpServletRequest request, HttpServletResponse response, String loginAct, String loginPwd) throws LoginException {
        //调用service处理student
        String ip = request.getRemoteAddr();//ip
        Map map = new HashMap<>();
        User user = userService.login(loginAct,loginPwd,ip);

        request.getSession().setAttribute("user",user); //放入session
        map.put("success",true);

        return map;
    }

    @RequestMapping("/exit.do")
    private void exit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().invalidate();//销毁session
        response.sendRedirect(request.getContextPath()+"/login.jsp");//重定向会login.jsp

    }

    @RequestMapping(value = "/resetPwd.do",method = RequestMethod.POST)
    @ResponseBody
    private Map<String,Boolean> resetPwd(HttpServletRequest request,String oldPwd,String newPwd) throws ResetException,Exception {

        User user = (User) request.getSession().getAttribute("user");
        Map map = new HashMap<>();
        String id = user.getId();//获得id
        //旧的密码是否正确
        oldPwd = MD5Util.getMD5(oldPwd);
        if(user.getLoginPwd().equals(oldPwd)){
            newPwd = MD5Util.getMD5(newPwd);
            boolean flag = userService.resetPwd(id,newPwd);
            if(flag){
                map.put("success",true);
                request.getSession().invalidate();//销毁session
            }
        }else{
            throw new ResetException("原密码错误！");
        }
        return map;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<User> pageList(@RequestParam Map map){
        String pageSizeStr = (String) map.get("pageSize");
        String pageNoStr = (String) map.get("pageNo");
        int pageSize = Integer.parseInt(pageSizeStr);
        int pageNo = Integer.parseInt(pageNoStr);
        int skipCount = (pageNo-1)*pageSize;
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        PaginationVO<User> vo = userService.pageList(map);

        return vo;
    }

    @RequestMapping("/delete.do")
    @ResponseBody
    private Map<String,Boolean> delete(String [] id){
        Map<String,Boolean>map = new HashMap();
        boolean flag = userService.delete(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/add.do")
    @ResponseBody
    private Map<String,Boolean> add(User user,HttpServletRequest request){
        Map<String,Boolean>map = new HashMap();
        User creator = (User)request.getSession().getAttribute("user");
        String pwd = MD5Util.getMD5(user.getLoginPwd());//密码加密
        user.setId(UUIDUtil.getUUID());
        user.setLoginPwd(pwd);
        user.setCreateTime(DateTimeUtil.getSysTime());
        user.setCreateBy(creator.getName());
        user.setEditBy("-");
        user.setEditTime("-");

        boolean flag = userService.add(user);
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        User user= userService.getDetail(id);
        request.setAttribute("user",user);
        request.getRequestDispatcher("/settings/qx/user/detail.jsp").forward(request,response);
    }

    @RequestMapping("/getUserInDetail.do")
    @ResponseBody
    private User getUserInDetail(String id) throws ServletException, IOException {
        User user= userService.getDetail(id);
        return user;
    }

    @RequestMapping("/edit.do")
    @ResponseBody
    private Map<String,Object> edit(User user,HttpServletRequest request){
        User editor =  (User) request.getSession().getAttribute("user");
        user.setEditBy(editor.getName());
        user.setEditTime(DateTimeUtil.getSysTime());
        Map<String,Object>map = userService.edit(user);
        return map;
    }
}
