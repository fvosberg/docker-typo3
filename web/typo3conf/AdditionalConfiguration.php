<?php

switch((string) \TYPO3\CMS\Core\Utility\GeneralUtility::getApplicationContext()) {
	case 'Development/Docker':
	case 'Production/Docker':
		$GLOBALS['TYPO3_CONF_VARS']['DB']['database'] = 'dev';
		$GLOBALS['TYPO3_CONF_VARS']['DB']['host']     = 'db';
		$GLOBALS['TYPO3_CONF_VARS']['DB']['username'] = 'dev';
		$GLOBALS['TYPO3_CONF_VARS']['DB']['password'] = 'dev';
}
