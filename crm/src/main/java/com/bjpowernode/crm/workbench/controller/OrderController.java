package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.ServiceFactory;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.GoodsService;
import com.bjpowernode.crm.workbench.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/workbench/Order")
public class OrderController {
    @Resource
    private OrderService orderService;
    @Resource
    private UserService userService;
    @Resource
    private GoodsService goodsService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    private List<User> getUserList() {

        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Order> pageList(@RequestParam Map<String,Object>map) {

        String pageNoStr = (String) map.get("pageNo");
        String pageSizeStr = (String) map.get("pageSize");

        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;

        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);


        PaginationVO<Order> vo = orderService.pageList(map);

        return vo;

    }


    @RequestMapping("/addOrder.do")
    @ResponseBody
    private Map<String,Boolean> addOrder(Order order, HttpServletRequest request) {

        User user = (User)request.getSession().getAttribute("user");
        order.setId(UUIDUtil.getUUID());//id
        order.setCreateBy(user.getName());
        order.setCreateTime(DateTimeUtil.getSysTime());//创建时间

        boolean flag = orderService.addOrder(order);
        Map<String,Boolean> map  =  new HashMap<>();
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/getUserListAndOrder.do")
    @ResponseBody
    private Map<String,Object> getUserListAndOrder(String id){
        Map<String,Object> map = new HashMap<>();
        Order order = orderService.getOrderById(id);
        List<User> userList = userService.getUserList();
        map.put("order",order);
        map.put("userList",userList);
        return map;
    }

    @RequestMapping("/updateOrder.do")
    @ResponseBody
    private Map updateOrder(Order order,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        order.setEditBy(user.getName());
        order.setEditTime(DateTimeUtil.getSysTime());

        System.out.println(order);

        boolean flag = orderService.updateOrder(order);
        Map map = new HashMap();
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/deleteOrder.do")
    @ResponseBody
    private Map deleteOrder(String[] id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = orderService.deleteOrder(id);
        map.put("success",flag);
        return map;
    }


    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Order order = orderService.getDetail(id);
        request.setAttribute("order",order);
        //重定向
        RequestDispatcher report = request.getRequestDispatcher("/workbench/clue/detail.jsp");
        report.forward(request,response);

    }


    @RequestMapping("/updateOrderInDetail.do")
    @ResponseBody
    private Map updateGoodInDetail(Order order,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        order.setEditBy(user.getName());
        order.setEditTime(DateTimeUtil.getSysTime());
        System.out.println(order);
        Map<String,Object> map = orderService.updateOrderInDetail(order);
        return map;
    }


    @RequestMapping("/showRemarkList.do")
    @ResponseBody
    private List<OrderRemark> showRemarkList(String orderId){

        List<OrderRemark> orderRemarkList = orderService.showRemarkList(orderId);
        return orderRemarkList;
    }


    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    private Map deleteRemark(String id){
        Map map  = new HashMap();
        boolean flag = orderService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    private Map addRemark(OrderRemark orderRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        orderRemark.setId(UUIDUtil.getUUID());//id
        orderRemark.setCreateBy(user.getName());
        orderRemark.setCreateTime(DateTimeUtil.getSysTime());
        orderRemark.setEditFlag("0");

        System.out.println(orderRemark);
        Map map = orderService.addRemark(orderRemark);
        return map;
    }


    @RequestMapping("/updateRemark.do")
    @ResponseBody
    private Map updateRemark(OrderRemark orderRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        orderRemark.setEditFlag("1");
        orderRemark.setEditBy(user.getName());
        orderRemark.setEditTime(DateTimeUtil.getSysTime());
        System.out.println(orderRemark);
        Map map = orderService.updateRemark(orderRemark);
        return map;
    }

    @RequestMapping("/getGoodListByOrderId.do")
    @ResponseBody
    private List<Goods> getGoodListByOrderId(String orderId){

        List<Goods> goodsList = goodsService.getGoodListByOrderId(orderId);
        return goodsList;
    }

    @RequestMapping("/unbund.do")
    @ResponseBody
    private Map<String,Boolean> unbund(String id){
        boolean flag = orderService.unbund(id);
        Map<String,Boolean> map = new HashMap<>();
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getGoodListByNameAndNotByOrderId")
    @ResponseBody
    private List<Goods> getGoodListByNameAndNotByOrderId(String name,String orderId){
        List<Goods> goodsList = goodsService.getGoodListByNameAndNotByOrderId(name,orderId);
        return goodsList;
    }


    @RequestMapping("/relate.do")
    @ResponseBody
    private Map<String,Boolean> relate(String[] id,String orderId){

        boolean flag = orderService.relate(id,orderId);
        Map<String,Boolean> map = new HashMap<>();
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/convert.do")
    @ResponseBody
    private void convert(String orderId,String transFlag,Tran tran,HttpServletRequest request,HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        String createBy = user.getName();//创建者
        if(transFlag!=null){

            tran.setId(UUIDUtil.getUUID());//id
            tran.setCreateTime(DateTimeUtil.getSysTime());//创建时间
            tran.setCreateBy(createBy);//创建者
        }else {
            tran = null;
        }
        System.out.println(tran);

        boolean flag = orderService.convert(orderId,tran,createBy);
        System.out.println("==================================================="+flag+"=============================================================");
        if(flag){

            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
        /*
         *
         *   为业务层传递的参数：
         *       1.必须传递的参数clueId,有了这个clueId之后我们才知道要转换哪条记录
         *       2.必须传递的参数t，因为在线索转换的过程中，有可能会临时创建一笔交易（业务层接受的t也有可能是个null）
         *       3.
         *
         * */

    }
}
