package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/workbench/Tran")
public class TranController {

    @Resource
    TranService tranService;
    @Resource
    UserService userService;
    @Resource
    ContactsService contactsService;

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Tran> pageList(@RequestParam Map<String,Object> map){
        String pageNoStr = (String) map.get("pageNo");
        String pageSizeStr = (String) map.get("pageSize");

        int pageNo = Integer.parseInt(pageNoStr);
        int pageSize = Integer.parseInt(pageSizeStr);

        int skipCount = (pageNo-1)*pageSize;
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);

        PaginationVO<Tran>vo = tranService.pageList(map);
        return vo;
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    private List<User> getUserList(Tran tran){
       List<User> userList = userService.getUserList();
       return userList;
    }


    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    private List<String> getCustomerName(String name){
       List<String> names = contactsService.getCustomerName(name);
       return names;
    }

    @RequestMapping("/getAllContacts.do")
    @ResponseBody
    private List<Contacts> getAllContacts(){
        List<Contacts> contactsList = contactsService.getAllContacts();
        return contactsList;
    }

    @RequestMapping("/searchContacts.do")
    @ResponseBody
    private List<Contacts> searchContacts(String name){
        List<Contacts> contactsList = contactsService.searchContacts(name);
        return contactsList;
    }

    @RequestMapping("/addTran.do")
    @ResponseBody
    private Map<String,Boolean> addTran(Tran tran,HttpServletRequest request){
        Map <String,Boolean> map = new HashMap<>();
        User user = (User) request.getSession().getAttribute("user");
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(user.getName());
        tran.setCreateTime(DateTimeUtil.getSysTime());

        boolean flag  = tranService.addTran(tran);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getUserListAndTran.do")
    @ResponseBody
    private void getUserListAndTran(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String,Object>map = new HashMap();
        Tran tran = tranService.getUserListAndTran(id);
        List<User> userList = userService.getUserList();

        ServletContext application = request.getServletContext();
        Map pMap = (Map) application.getAttribute("pMap");
        tran.setPossibility((String) pMap.get(tran.getStage()));


        map.put("userList",userList);
        map.put("tran",tran);

        request.setAttribute("userListAndTran",map);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);

    }

    @RequestMapping("/updateTran.do")
    @ResponseBody
    private Map<String,Boolean> updateTran(Tran tran,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        Map<String,Boolean> map = new HashMap();
        tran.setEditTime(DateTimeUtil.getSysTime());
        tran.setEditBy(user.getName());
        boolean flag = tranService.updateTran(tran);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/deleteTran.do")
    @ResponseBody
    private Map<String,Boolean> deleteTran(String [] id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = tranService.deleteTran(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Tran tran = tranService.getDetail(id);
        ServletContext application = request.getServletContext();
        Map pMap = (Map) application.getAttribute("pMap");
        tran.setPossibility((String) pMap.get(tran.getStage()));
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    @RequestMapping("/showGoodList.do")
    @ResponseBody
    private List<Goods> showGoodList(String id){
        List<Goods> goods = tranService.showGoodList(id);
        return goods;
    }

    @RequestMapping("/unbund.do")
    @ResponseBody
    private Map<String,Boolean> unbund(String id){
        Map<String,Boolean> map = new HashMap<>();
        Boolean flag = tranService.unbund(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/orderGood.do")
    @ResponseBody
    private Map<String,Boolean> orderGood(String tranId,String goodId,String amount){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = tranService.orderGood(tranId,goodId,amount);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/showRemarkList.do")
    @ResponseBody
    private List<TranRemark> showRemarkList(String tranId){
        List<TranRemark> tranRemarkList = tranService.showRemarkList(tranId);
        return tranRemarkList;
    }


    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    private Map deleteRemark(String id){
        Map map  = new HashMap();
        boolean flag = tranService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }


    @RequestMapping("/updateRemark.do")
    @ResponseBody
    private Map updateRemark(TranRemark tranRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        tranRemark.setEditFlag("1");
        tranRemark.setEditBy(user.getName());
        tranRemark.setEditTime(DateTimeUtil.getSysTime());
        Map map = tranService.updateRemark(tranRemark);
        return map;
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    private Map addRemark(TranRemark tranRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        tranRemark.setId(UUIDUtil.getUUID());//id
        tranRemark.setCreateBy(user.getName());
        tranRemark.setCreateTime(DateTimeUtil.getSysTime());
        tranRemark.setEditFlag("0");

        Map map = tranService.addRemark(tranRemark);
        return map;
    }

    @RequestMapping("/showTranHistoryList.do")
    @ResponseBody
    private List<TranHistory> showTranHistoryList(String tranId,HttpServletRequest request){
        List<TranHistory> tranHistoryList = tranService.showTranHistoryList(tranId);
        ServletContext application = request.getServletContext();
        Map pMap = (Map)application.getAttribute("pMap");
        //遍历集合处理可能性
        for(TranHistory history:tranHistoryList){
            history.setPossibility((String) pMap.get(history.getStage()));
        }

        return tranHistoryList;
    }

    @RequestMapping("/changeStage.do")
    @ResponseBody
    private Map<String,Object> changeStage(Tran tran,HttpServletRequest request){
        Map<String,Object> map = new HashMap<>();
        User user = (User) request.getSession().getAttribute("user");
        ServletContext application = request.getServletContext();
        Map pMap = (Map)application.getAttribute("pMap");
        String possibility = (String) pMap.get(tran.getStage());

        tran.setPossibility(possibility);
        tran.setEditBy(user.getName());
        tran.setEditTime(DateTimeUtil.getSysTime());

        boolean flag = tranService.changeStage(tran);
        map.put("success",flag);
        if(flag){
            map.put("tran",tran);
        }
        return map;
    }
}
