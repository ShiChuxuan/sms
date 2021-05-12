package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Supplier;
import com.bjpowernode.crm.workbench.service.SupplierService;
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
import java.util.Map;

@Controller
@RequestMapping("/workbench/Supplier")
public class SupplierController {

    @Resource
    private SupplierService supplierService;


    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Supplier> pageList(@RequestParam Map<String,Object> map){

        String pageSizeStr = (String) map.get("pageSize");
        String pageNoStr = (String)map.get("pageNo");

        int pageSize =  Integer.parseInt(pageSizeStr);
        int pageNo = Integer.parseInt(pageNoStr);
        int skipCount = (pageNo-1)*pageSize;

        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Supplier> vo = supplierService.pageList(map);
        return vo;
    }


    @RequestMapping("/addSupplier.do")
    @ResponseBody
    private Map<String,Boolean> addSupplier(Supplier supplier, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        Map<String,Boolean> map = new HashMap<>();
        supplier.setId(UUIDUtil.getUUID());
        supplier.setCreateTime(DateTimeUtil.getSysTime());
        supplier.setCreateBy(user.getName());

        boolean flag = supplierService.addSupplier(supplier);
        map.put("success",flag);
        return map;

    }

    @RequestMapping("/getSupplier.do")
    @ResponseBody
    private Supplier getSupplier(String id){
        Supplier supplier = supplierService.getSupplier(id);
        return supplier;
    }

    @RequestMapping("/updateSupplier.do")
    @ResponseBody
    private Map<String,Boolean> updateSupplier(Supplier supplier,HttpServletRequest request){
        Map<String,Boolean> map = new HashMap<>();
        User user = (User) request.getSession().getAttribute("user");
        supplier.setEditTime(DateTimeUtil.getSysTime());
        supplier.setCreateBy(user.getName());
        boolean flag = supplierService.updateSupplier(supplier);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/deleteSupplier.do")
    @ResponseBody
    private Map<String,Boolean> deleteSupplier(String [] id){
        Map<String,Boolean> map = new HashMap<>();

        boolean flag = supplierService.deleteSupplier(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/getDetail.do")
    @ResponseBody
    private void getDetail(String id, HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
       Supplier supplier = supplierService.getDetail(id);
       request.setAttribute("supplier",supplier);
       request.getRequestDispatcher("/workbench/supplier/detail.jsp").forward(request,response);
    }

    @RequestMapping("/updateSupplierInDetail.do")
    @ResponseBody
    private Map<String,Object> updateSupplierInDetail(Supplier supplier,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        supplier.setEditTime(DateTimeUtil.getSysTime());
        supplier.setEditBy(user.getName());
        Map<String,Object> map = supplierService.updateSupplierInDetail(supplier);
        return map;
    }

}
