package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;
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
import java.util.Set;

@RequestMapping("/workbench/Customer")
@Controller
public class CustomerController {
    @Resource
    private CustomerService customerService;
    @Resource
    private UserService userService;

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Customer> pageList(@RequestParam Map<String,Object> map){

        String pageSizeStr = (String) map.get("pageSize");
        String pageNoStr = (String)map.get("pageNo");

        int pageSize =  Integer.parseInt(pageSizeStr);
        int pageNo = Integer.parseInt(pageNoStr);
        int skipCount = (pageNo-1)*pageSize;

        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Customer> vo = customerService.pageList(map);
        return vo;
    }

    @RequestMapping("/getUserList.do")
    @ResponseBody
    private List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/addCustomer.do")
    @ResponseBody
    private Map<String,Boolean> addCustomer(Customer customer, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        Map<String,Boolean> map = new HashMap<>();
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setCreateBy(user.getName());

        boolean flag = customerService.addCustomer(customer);
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/getUserListAndCustomer.do")
    @ResponseBody
    private Map<String,Object> getUserListAndCustomer(String id){
        Map <String,Object> map = new HashMap<>();
        List<User> userList = userService.getUserList();
        Customer customer = customerService.getCustomerById(id);

        map.put("userList",userList);
        map.put("customer",customer);

        return map;
    }


    @RequestMapping("/updateCustomer.do")
    @ResponseBody
    private Map<String,Boolean> updateCustomer(Customer customer,HttpServletRequest request){
        Map map = new HashMap();
        User user = (User) request.getSession().getAttribute("user");
        customer.setEditBy(user.getName());
        customer.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = customerService.updateCustomer(customer);
        map.put("success",flag);

        return map;
    }

    @RequestMapping("/deleteCustomer.do")
    @ResponseBody
    private Map<String,Boolean> deleteCustomer(String [] id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = customerService.deleteCustomer(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Customer customer =  customerService.getDetail(id);
        request.setAttribute("customer",customer);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }


    @RequestMapping("/updateCustomerInDetail.do")
    @ResponseBody
    private Map<String,Object> updateCustomerInDetail(Customer customer,HttpServletRequest request){
        Map map = new HashMap();
        User user = (User) request.getSession().getAttribute("user");
        customer.setEditBy(user.getName());
        customer.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = customerService.updateCustomer(customer);
        Customer customer2 = customerService.getCustomerById(customer.getId());

        map.put("success",flag);
        map.put("customer",customer2);
        return map;
    }


    @RequestMapping("/showRemarkList.do")
    @ResponseBody
    private List<CustomerRemark> showRemarkList(String customerId){

        List<CustomerRemark> customerRemarkList = customerService.showRemarkList(customerId);
        return customerRemarkList;
    }


    @RequestMapping("/addRemark.do")
    @ResponseBody
    private Map addRemark(CustomerRemark customerRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        customerRemark.setId(UUIDUtil.getUUID());//id
        customerRemark.setCreateBy(user.getName());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setEditFlag("0");

        System.out.println(customerRemark);
        Map map = customerService.addRemark(customerRemark);
        return map;
    }


    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    private Map deleteRemark(String id){
        Map map  = new HashMap();
        boolean flag = customerService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    private Map updateRemark(CustomerRemark customerRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        customerRemark.setEditFlag("1");
        customerRemark.setEditBy(user.getName());
        customerRemark.setEditTime(DateTimeUtil.getSysTime());
        Map map = customerService.updateRemark(customerRemark);
        return map;
    }


    @RequestMapping("/showTranList.do")
    @ResponseBody
    private List<Tran> showTranList(String customerId){

        List<Tran> tranList = customerService.showTranList(customerId);
        return tranList;
    }

    @RequestMapping("/deleteTran.do")
    @ResponseBody
    private Map<String,Boolean> deleteTran(String id){
        Map<String,Boolean>map = new HashMap();
        boolean flag = customerService.deleteTran(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/showContactList.do")
    @ResponseBody
    private List<Contacts> showContactList(String CustomerId){
        List<Contacts> contactsList  = customerService.showContactList(CustomerId);
        return contactsList;
    }

    @RequestMapping("/deleteContact.do")
    @ResponseBody
    private Map<String,Boolean> deleteContact(String id){
        Map<String,Boolean>map = new HashMap();
        boolean flag = customerService.deleteContact(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/addContact.do")
    @ResponseBody
    private Map<String,Boolean> addContact(Contacts contacts,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        Map map = new HashMap();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setCreateBy(user.getName());

        boolean flag =customerService.addContact(contacts);
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/getGoodListByCustomerId.do")
    @ResponseBody
    private List<Goods> getGoodListByCustomerId(String customerId){
        List<Goods> goodsList = customerService.getGoodListByCustomerId(customerId);
        return goodsList;
    }

    @RequestMapping("/unbund.do")
    @ResponseBody
    private Map<String,Boolean> unbund(String id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = customerService.unbund(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getGoodListByNameAndNotByCustomerId")
    @ResponseBody
    private List<Goods> getGoodListByNameAndNotByCustomerId(String customerId,String name){
        List<Goods> goodsList = customerService.getGoodListByNameAndNotByCustomerId(customerId,name);
        return goodsList;
    }

    @RequestMapping("/relate.do")
    @ResponseBody
    private Map<String,Boolean> relate(String customerId,String[] id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = customerService.relate(customerId,id);
        map.put("success",flag);
        return map;

    }
}
