package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.ServiceFactory;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Goods;
import com.bjpowernode.crm.workbench.domain.GoodsRemark;
import com.bjpowernode.crm.workbench.domain.Supplier;
import com.bjpowernode.crm.workbench.service.GoodsService;
import com.bjpowernode.crm.workbench.service.SupplierService;
import com.bjpowernode.crm.workbench.service.impl.GoodsServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.SupplierServiceImpl;
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

@Controller
@RequestMapping("/workbench/Goods")
public class GoodsController {
    @Resource
    private GoodsService goodsService;
    @Resource
    private SupplierService supplierService;


    @RequestMapping("/supplierList.do")
    @ResponseBody
    private List<Supplier> getSupplierList() {

        List<Supplier> supplierList = supplierService.getSupplierList();
        return supplierList;
    }

    @RequestMapping("/addGood.do")
    @ResponseBody
    private Map<String,Boolean> addGood(Goods goods,HttpServletRequest request) {

        User user = (User)request.getSession().getAttribute("user");

        String firstDate = request.getParameter("firstDate");
        String createBy = user.getName();

        goods.setId(UUIDUtil.getUUID());//id
        goods.setLastDate(firstDate);
        goods.setCreateTime(DateTimeUtil.getSysTime());
        goods.setCreateBy(createBy);


        Boolean flag = goodsService.addGood(goods);
        Map map = new HashMap<>();
        map.put("success",flag);

        return map;

    }


    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Goods> pageList(@RequestParam Map<String,Object>map) {

        String pageNoStr = (String) map.get("pageNo");
        String pageSizeStr = (String) map.get("pageSize");

        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;

        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);

        PaginationVO<Goods>vo = goodsService.pageList(map);


        return vo;

    }


    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        System.out.println(id);
        Goods good = goodsService.getDetail(id);
        request.setAttribute("good",good);
        //重定向
        RequestDispatcher report = request.getRequestDispatcher("/workbench/activity/detail.jsp");
        report.forward(request,response);

    }


    @RequestMapping("/deleteGood.do")
    @ResponseBody
    private Map deleteGood(String[] id){
        Map<String,Boolean> map = new HashMap<>();
        boolean flag = goodsService.deleteGood(id);
        map.put("success",flag);
        return map;
    }


    @RequestMapping("/getSupplierListAndGood.do")
    @ResponseBody
    private Map getSupplierListAndGood(String id){
        Map<String,Object> map = new HashMap<>();
        Goods good = goodsService.getGoodById(id);
        List<Supplier> supplierList = supplierService.getSupplierList();
        map.put("good",good);
        map.put("supplierList",supplierList);
        return map;
    }

    @RequestMapping("/updateGood.do")
    @ResponseBody
    private Map updateGood(Goods good,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        good.setEditBy(user.getName());
        good.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = goodsService.updateGood(good);
        Map map = new HashMap();
        map.put("success",flag);
        return map;
    }


    @RequestMapping("/updateGoodInDetail.do")
    @ResponseBody
    private Map updateGoodInDetail(Goods good,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        good.setEditBy(user.getName());
        good.setEditTime(DateTimeUtil.getSysTime());
        System.out.println(good);
        Map<String,Object> map = goodsService.updateGoodInDetail(good);
        return map;
    }

    @RequestMapping("/showRemarkList.do")
    @ResponseBody
    private List<GoodsRemark> showRemarkList(String goodId){

        List<GoodsRemark> goodsRemarkList = goodsService.showRemarkList(goodId);
        return goodsRemarkList;
    }

    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    private Map deleteRemark(String id){
        Map map  = new HashMap();
        boolean flag = goodsService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }


    @RequestMapping("/updateRemark.do")
    @ResponseBody
    private Map updateRemark(GoodsRemark goodsRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        goodsRemark.setEditFlag("1");
        goodsRemark.setEditBy(user.getName());
        goodsRemark.setEditTime(DateTimeUtil.getSysTime());
        System.out.println(goodsRemark);
        Map map = goodsService.updateRemark(goodsRemark);
        return map;
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    private Map addRemark(GoodsRemark goodsRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        goodsRemark.setId(UUIDUtil.getUUID());//id
        goodsRemark.setCreateBy(user.getName());
        goodsRemark.setCreateTime(DateTimeUtil.getSysTime());
        goodsRemark.setEditFlag("0");

        System.out.println(goodsRemark);
        Map map = goodsService.addRemark(goodsRemark);
        return map;
    }

    @RequestMapping("/getGoodsName.do")
    @ResponseBody
    private List<Goods> getGoodByName(String name){
        List<Goods> goods = goodsService.getGoodByName(name);
        return goods;
    }

}
