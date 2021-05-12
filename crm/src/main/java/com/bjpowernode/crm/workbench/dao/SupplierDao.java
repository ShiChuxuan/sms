package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Supplier;

import java.util.List;
import java.util.Map;

public interface SupplierDao {
    List<Supplier> getSupplierList();

    List<Supplier> pageList(Map<String, Object> map);

    int getCount(Map<String, Object> map);

    int addSupplier(Supplier supplier);

    Supplier getSupplier(String id);

    int updateSupplier(Supplier supplier);

    int deleteSupplier(String[] id);
}
