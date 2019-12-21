//
//  ViewController.swift
//  MyDiet
//
//  Created by Артем Чиглинцев on 11/12/2019.
//  Copyright © 2019 Артем Чиглинцев. All rights reserved.
//

import UIKit
import SVGKit

class TabBarViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayViewController = TodayViewController()
        let recipesViewController = RecipesViewController()
        let productsViewController = ProductsViewController()
        
        todayViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar"), selectedImage: nil)
        recipesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "recipes"), selectedImage: nil)
        productsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "shopping-list"), selectedImage: nil)
        
        viewControllers = [todayViewController,recipesViewController, productsViewController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[0].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItems[1].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItems[2].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    
    
    
    


}


