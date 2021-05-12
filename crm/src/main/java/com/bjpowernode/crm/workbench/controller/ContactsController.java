package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
@RequestMapping("/workbench/Contacts")
public class ContactsController {
    @Resource
    private ContactsService contactsService;
    @Resource
    private UserService userService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    private List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Contacts> pageList(@RequestParam Map<String,Object> map){
        String pageNoStr = (String) map.get("pageNo");
        String pageSizeStr = (String)map.get("pageSize");

        int pageNo = Integer.parseInt(pageNoStr);
        int pageSize = Integer.parseInt(pageSizeStr);

        int skipCount = (pageNo-1)*pageSize;

        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Contacts> vo = contactsService.pageList(map);
        return vo;
    }

    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    private List<String> getCustomerName(String name){
        List<String> nameList = contactsService.getCustomerName(name);
        return nameList;
    }


    @RequestMapping("/addContacts.do")
    @ResponseBody
    private Map<String,Boolean> addContacts(Contacts contacts, HttpServletRequest request){
        User user = (User)request.getSession().getAttribute("user");
        Map<String,Boolean> map = new HashMap<>();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateBy(user.getName());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag = contactsService.addContacts(contacts);
        map.put("success",flag);

        return map;
    }

    @RequestMapping("/getUserListAndContacts.do")
    @ResponseBody
    private Map<String,Object> getUserListAndContacts(String id){

        System.out.println("id-------------------------->"+id);
        Map<String,Object>map = contactsService.getUserListAndContacts(id);
        return map;
    }


    @RequestMapping("/updateContacts.do")
    @ResponseBody
    private Map<String,Boolean> updateContacts(Contacts contacts,HttpServletRequest request){
        Map<String,Boolean> map = new HashMap<>();
        User user = (User)request.getSession().getAttribute("user");
        contacts.setEditTime(DateTimeUtil.getSysTime());
        contacts.setEditBy(user.getName());

        boolean flag = contactsService.updateContacts(contacts);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/deleteContact.do")
    @ResponseBody
    private Map<String,Boolean> deleteContact(String[]id){
        Map<String,Boolean>map = new HashMap();
        boolean flag = contactsService.deleteContact(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Contacts contacts = contactsService.getDetail(id);
        request.setAttribute("contacts",contacts);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
    }

    @RequestMapping("/updateContactsInDetail.do")
    @ResponseBody
    private Map<String,Object> updateContactsInDetail(Contacts contacts,HttpServletRequest request){
        User user = (User)request.getSession().getAttribute("user");
        Map<String, Object> map = new HashMap<>();
        contacts.setEditBy(user.getName());
        contacts.setEditTime(DateTimeUtil.getSysTime());

        boolean flag = contactsService.updateContacts(contacts);
        contacts = contactsService.getDetail(contacts.getId());

        map.put("success",flag);
        map.put("contacts",contacts);

        return map;
    }

    @RequestMapping("/showRemarkList.do")
    @ResponseBody
    private List<ContactsRemark> showRemarkList(String contactsId){
        List<ContactsRemark> contactsRemarks = contactsService.showRemarkList(contactsId);
        return contactsRemarks;
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    private Map<String,Object> updateRemark(ContactsRemark contactsRemark,HttpServletRequest request){
        User user = (User)request.getSession().getAttribute("user");
        contactsRemark.setEditBy(user.getName());
        contactsRemark.setEditTime(DateTimeUtil.getSysTime());
        contactsRemark.setEditFlag("1");
        Map<String,Object> map  = contactsService.updateRemark(contactsRemark);
        return map;
    }

    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    private Map deleteRemark(String id){
        Map map  = new HashMap();
        boolean flag = contactsService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    private Map addRemark(ContactsRemark contactsRemark, HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        contactsRemark.setId(UUIDUtil.getUUID());//id
        contactsRemark.setCreateBy(user.getName());
        contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
        contactsRemark.setEditFlag("0");

        Map map = contactsService.addRemark(contactsRemark);
        return map;
    }



}
