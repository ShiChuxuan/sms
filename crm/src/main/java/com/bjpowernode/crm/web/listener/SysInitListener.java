package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.util.ServiceFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    /*
    *
    *   该方法是用来监听全局作用域对象的方法，当服务器启动，全局作用域对象就开始创建
    *   对象创建完毕后，马上执行该方法
    *
    *   sce:该参数能够取得监听的对象
    *       监听的是什么对象，就可以通过该参数取得什么对象
    *       例如我们现在监听的是全局作用域对象
    *
    * */
    @Override
    public void contextInitialized(ServletContextEvent event) {

        ServletContext application = event.getServletContext();
        DicService service = (DicService) WebApplicationContextUtils.getWebApplicationContext(application).getBean("dicServiceImpl");



        System.out.println("开始处理数据字典...");
        Map<String, List<DicValue>> map = service.getAll();
        //将map解析为全局作用域对象中保存的键值对
        Set<String>set = map.keySet();
        for(String key:set){
            List<DicValue>value = map.get(key);
            application.setAttribute(key,value);
        }
        System.out.println("处理数据字典结束！");


        ResourceBundle bundle = ResourceBundle.getBundle("conf/Stage2Possibility");
        Map pMap = new HashMap();
        Set<String> set1 = bundle.keySet();
        for(String key:set1){
            String value=  bundle.getString(key);
            pMap.put(key,value);
        }
        application.setAttribute("pMap",pMap);

    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        //System.out.println("全局作用域对象被销毁了");
    }
}
