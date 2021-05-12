package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.SupplierDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Supplier;
import com.bjpowernode.crm.workbench.service.SupplierService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SupplierServiceImpl implements SupplierService {
    @Resource
    private SupplierDao supplierDao;

    @Override
    @Transactional
    public List<Supplier> getSupplierList() {
        List<Supplier> supplierList = supplierDao.getSupplierList();
        return supplierList;
    }

    @Override
    @Transactional
    public PaginationVO<Supplier> pageList(Map<String, Object> map) {
        PaginationVO<Supplier> vo = new PaginationVO<>();
        List<Supplier> supplierList = supplierDao.pageList(map);
        int count  = supplierDao.getCount(map);
        vo.setDataList(supplierList);
        vo.setTotal(count);
        return vo;
    }

    @Override
    @Transactional
    public boolean addSupplier(Supplier supplier) {
        boolean flag = false;
        int count = supplierDao.addSupplier(supplier);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    public Supplier getSupplier(String id) {
        Supplier supplier = supplierDao.getSupplier(id);

        return supplier;
    }

    @Override
    @Transactional
    public boolean updateSupplier(Supplier supplier) {
        boolean flag = false;
        int count  = supplierDao.updateSupplier(supplier);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    @Transactional
    public boolean deleteSupplier(String[] id) {
        boolean flag = false;
        int count = supplierDao.deleteSupplier(id);
        if(count==id.length){
            flag = true;
        }
        return flag;
    }

    @Override
    public Supplier getDetail(String id) {
        Supplier supplier = supplierDao.getSupplier(id);

        return supplier;
    }

    @Override
    @Transactional
    public Map<String, Object> updateSupplierInDetail(Supplier supplier) {
        Map<String,Object> map = new HashMap<>();
        boolean flag = false;
        int count = supplierDao.updateSupplier(supplier);
        if(count==1){
            Supplier supplier1 = supplierDao.getSupplier(supplier.getId());
            flag = true;
            map.put("supplier",supplier1);
        }
        map.put("success",flag);
        return map;
    }
}
