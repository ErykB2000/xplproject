xpl_free

v0.1
	Premiere version publi�e
	Cette application se connecte sur votre console de gestion free.
		- r�cup�re certains �l�ments d'information utiles (adresse ip publique, passerelle, adresse mac, version freebox)
		- surveillance r�guli�re de la liste des messages t�l�phoniques laiss�s en attente
			- notification sur le r�seau xPL de la pr�sence d'un message t�l�phonique
			- download du fichier enregistr�
		- Permet l'allumage et l'extinction de la freebox � partir de messages xPL

	L'application se configure � l'aide de xPL Hal - les param�tres � fournir sont les suivants :
		Username : votre identifiant free
		Password : le mot de passe associ� � cet identifiant
		StoreDir : r�pertoire pour la d�pose des fichiers wav de la messagerie vocale
		Webroot	 : localisation de la racine web des applications xpl (commun aux autres application xPL clinique).
				T�l�charger et d�compresser le fichier "Web root for xpl web server apps" disponible dans la section download de glh33.free.fr
		fbox-x10 : code x10 du module (type AM12) sur lequel est connect� la Freebox
		fboxhd-x10 : code x10 du module (type AM12) sur lequel est connect� le boitier TV Freebox
		polling  : d�lai d'interrogation de la page de messagerie vocale

	
Todo : 
	Quand le d�lai de polling est trop important, la connexion ouverte initialement ne persiste pas, on obtient "Error=2"
		=> catcher l'erreur et r�ouvrir la connexion