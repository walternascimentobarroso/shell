#!/bin/bash
LinhaMesg=$((`tput lines` - 3))
TotCols=$(tput cols)		
module="
class Module {
    
    //chama o module.config.php(criar rotas)
    public function getConfig() {
        return include __DIR__ . '/config/module.config.php';
    }

    //Configura namespace
    public function getAutoloaderConfig() {
        return array(
            'Zend\Loader\ClassMapAutoloader' => array(
                __DIR__ . '/autoload_classmap.php'
            ),
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }

}"
clear
telaM2Tool="====================M2TOOL=================="
echo $telaM2Tool
echo "Informe o caminho do seu projeto:
Ex.: /var/www/nomedoprojeto";read projeto
cd $projeto/vendor/bin/
clear
echo $telaM2Tool
echo "Informe o nome do seu modulo (em minusculo):";read mMinusculo
mMaiusculo=`echo -e "$mMinusculo" | sed -r 's/(^.|[ ]+.)/\U&/g'`
clear
echo $telaM2Tool
echo "Informe o nome da sua tabela (em minusculo):";read tMinusculo
tMaiusculo=`echo -e "$tMinusculo" | sed -r 's/(^.|[ ]+.)/\U&/g'`
clear
echo $telaM2Tool
moduleConfig="
//configurando rotas
return array(
    'router' => array(
        'routes' => array(
            //rota(s)
            '$tMinusculo' => array(
                'type' => 'Segment',
                'options' => array(
                    'route' => '/$tMinusculo[/:action]', 
                    'defaults' => array(
                        'controller' => '$tMinusculo',
                        'action' => 'getAll',        
                    ),
                ),
            ),
        ),
    ),
    //configura os controllers
    'controllers' => array(
        'invokables' => array(
            '$tMinusculo' => '$mMaiusculo\Controller\\${tMaiusculo}Controller', 
        ),
    ),
    //configurações extra da aplicação
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions' => true,
        'doctype' => 'HTML5',
        'not_found_template' => 'error/404',
        'exception_template' => 'error/index',
        'template_map' => array(
            'layout/layout'      => __DIR__ . '/../../Common/view/layout/layout.phtml',
            'error/404'          => __DIR__ . '/../../Common/view/error/404.phtml',
            'error/index'        => __DIR__ . '/../../Common/view/error/index.phtml',
            'common/index/index' => __DIR__ . '/../../Common/view/common/index/index.phtml',
            'generico'           => __DIR__ . '/../../Common/view/common/abstract/generico.phtml'
        ),
        'template_path_stack' => array(
            __DIR__ . '/../view',
        ),
    ),
    //Configuração do Doctrine
    'doctrine' => array(
        'driver' => array(
            __NAMESPACE__ . '_driver' => array(
                'class' => 'Doctrine\ORM\Mapping\Driver\AnnotationDriver',
                'cache' => 'array',
                'paths' => array(__DIR__ . '../src/' . __NAMESPACE__ . '/Entity')
            ),
            'orm_default' => array(
                'drivers' => array(
                    __NAMESPACE__ . '\\\Entity' => __NAMESPACE__ . '_driver'
                )
            )
        )
    )
);"
mkdir -p ../../module/$mMaiusculo/config
mkdir -p ../../module/$mMaiusculo/src/$mMaiusculo/Controller
php doctrine-module orm:convert-mapping --filter="$tMaiusculo" --from-database annotation module/$mMaiusculo/src/$mMaiusculo/Entity
echo -e "<?php\n\nnamespace $mMaiusculo;\n$moduleConfig;" >> ../../module/$mMaiusculo/config/module.config.php
echo -e "<?php\n\nnamespace $mMaiusculo;\n\nclass ${tMaiusculo}Controller{\n};" >> ../../module/$mMaiusculo/src/$mMaiusculo/Controller/${tMaiusculo}Controller.php
echo -e "<?php\n\nnamespace $mMaiusculo;\n$mMaiusculo" >> ../../module/$mMaiusculo/Module.php
php classmap_generator.php -l ../../module/$mMaiusculo