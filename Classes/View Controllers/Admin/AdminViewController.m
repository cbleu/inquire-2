//
//  AdminViewController.m
//  inquire 2
//
//  Created by Nicolas Garnault on 15/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "AdminViewController.h"
#import "LoginViewController.h"
#import "inquireAppDelegate.h"
#import "ContentManager.h"
#import "SurveyDescription.h"
#import "AppCredentials.h"
#import "UserMainViewController.h"
#import "SurveyConfiguration.h"
#import "URLHelper.h"
#import "OpenUDID.h"
#import "AdminLoadingView.h"

@interface AdminViewController ()

- (void)launchUserForm:(id)sender;
- (void)displayLoginScreen:(id)sender;
- (NSInteger)numberOfResultsToPost;
- (void)setLoading:(BOOL)loading withTitle:(NSString *)title;
@end


@implementation AdminViewController

@synthesize shouldDisplayLoginController;

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    if((self = [super initWithCoder:aDecoder])) {
        shouldDisplayLoginController = YES;
        allowedSurveys = [[NSMutableArray alloc] init];
        loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    if((self = [super initWithStyle:UITableViewStyleGrouped])) {
        shouldDisplayLoginController = YES;
        allowedSurveys = [[NSMutableArray alloc] init];
        loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
// begin cbleu fix
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
// end cbleu fix

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"afficher le formulaire", @"")
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(launchUserForm:)];

// begin cbleu fix
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Retour au login", @"")
//                                                                              style:UIBarButtonItemStyleBordered
//                                                                             target:self
//                                                                             action:@selector(displayLoginScreen:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Retour au login", @"")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(displayLoginScreen:)];
// end cbleu Fix
    
}

- (void)viewWillAppear:(BOOL)animated {
// begin cbleu fix
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
// end cbleu fix

	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    // begin cbleu fix
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidAppear:animated];
    // end cbleu fix

    [self.tableView reloadData];
    if(shouldDisplayLoginController) {
        shouldDisplayLoginController = NO;
        [self displayLoginScreen:nil];
    }

}

#pragma mark --
#pragma mark Rotation related
// < IOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// IOS6
/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
 */

// begin cbleu fix

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    return UIInterfaceOrientationMaskAll;
//}

// end cbleu fix

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section > 0) {
        return 80.0;
    }
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return MAX([allowedSurveys count], 1);
    } else if(section == 1) {
        return 1;
    } else if(section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.numberOfLines = 10;
    }

    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;

    if(indexPath.section == 0) {
        if([allowedSurveys count] == 0) {
            cell.textLabel.text = NSLocalizedString(@"Aucune enquête disponible", @"");
        } else {
            SurveyDescription *d = [allowedSurveys objectAtIndex:indexPath.row];
            cell.textLabel.text = d.title;
            cell.detailTextLabel.text = nil;

            if([[AppCredentials currentSurveyId] isEqualToString:d.surveyId]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                if(![[AppCredentials currentSurveyDeploymentId] isEqualToString:d.surveyDeploymentId]) {
                    cell.detailTextLabel.text = NSLocalizedString(@"Une nouvelle version de l'enquête existe", @"");
                }
            }
        }
    } else if(indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"Exporter les immédiatement résultats de l'enquête", @"");
        
        NSInteger numberOfLines = [self numberOfResultsToPost];
        if(!numberOfLines) {
            cell.detailTextLabel.text = NSLocalizedString(@"Il n'y a aucun résultat à exporter pour le moment.", @"");
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Nombre de résultats à exporter : %d.", @""), numberOfLines];
        }
    } else if(indexPath.section == 2) {
        cell.textLabel.text = NSLocalizedString(@"Désassocier l'iPad du compte utilisateur", @"");
        cell.detailTextLabel.text = NSLocalizedString(@"Désassocier l'iPad permettra d'associer un autre périphérique au compte actuellement utilisé.\nAttention : toutes les données de l'application associées aux enquêtes seront effacées.", @"");
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return NSLocalizedString(@"Enquêtes sélectionnables", @"");
    } else if(section == 1) {
        return NSLocalizedString(@"Exporter immédiatement les données", @"");
    } else if(section == 2) {
        return NSLocalizedString(@"Désassocier l'iPad", @"");
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return NSLocalizedString(@"Sélectionnez l'enquête que vous souhaitez associer à cet iPad.\nPensez à exporter vos résultats avant de changer d'enquête, car ceux-ci seront effacés.", @"");
    }
    else if(section == 1) {
        
        NSString *lastExport = [AppCredentials lastResultsPostDateTime];
        if(lastExport == nil) {
            lastExport = NSLocalizedString(@"Aucune donné n'a encore été exportée.", @"");
        } else {
            lastExport = [NSString stringWithFormat:NSLocalizedString(@"Date du dernier export : %@", @""), lastExport];
        }
        
        return [NSString stringWithFormat:@"%@\n%@",
                NSLocalizedString(@"Profitez de votre connexion pour exporter les données d'enquête récoltées.", @""),
                lastExport];
    }
    else if(section == 2) {
        NSString *s = NSLocalizedString(@"Pour administrer vos enquêtes, rendez-vous sur http://www.inquire.mu/log\n\n%@", @"");

        s = [NSString stringWithFormat:s, [NSString stringWithFormat:@"build %@",
             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        
        return s;
    }
    return @"";
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];

    if(indexPath.section == 0 && [allowedSurveys count]) {
        if([self numberOfResultsToPost] > 0) {
            currentOperation = AdminViewControllerOperationChangeConfiguration;
            configurationToLoad = indexPath.row;

            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", @"")
                                       message:NSLocalizedString(@"Des résultats stockés sur l'iPad n'ont pas été exportés, ceux-ci seront supprimés lors de l'installation de la nouvelle enquête. Êtes-vous certain de vouloir continuer ?", @"")
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Annuler", @"")
                              otherButtonTitles:NSLocalizedString(@"Continuer", @""), nil] show];
        } else {
            SurveyDescription *d = [allowedSurveys objectAtIndex:indexPath.row];
            [[self sharedContentManager] fetchSurveyConfigurationForSurveyId:d.surveyId];

            //
            [self setLoading:YES withTitle:NSLocalizedString(@"Téléchargement de l'enquête", @"")];
        }
    } else if(indexPath.section == 1) {
        //
        if([self numberOfResultsToPost]) {
            NSString *formResults = [NSString stringWithContentsOfFile:[UrlHelper formResultsFilePath]
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
            
            NSString *optinResults = [NSString stringWithContentsOfFile:[UrlHelper optinResultsFilePath]
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];

            if([formResults length] > 0) {
                [[self sharedContentManager] postSurveysResultsWithSurveyId:[AppCredentials currentSurveyId]
                                                         surveyDeploymentId:[AppCredentials currentSurveyDeploymentId]
                                                                formResults:formResults
                                                               optinResults:optinResults];
            }

            //
            [self setLoading:YES withTitle:NSLocalizedString(@"Envoi des résultats récoltés", @"")];

        } else {
            [loginController displayErrorMessageWithTitle:NSLocalizedString(@"Aucune donnée à poster", @"")
                                                  message:NSLocalizedString(@"Aucune donnée à poster n'existe pour le moment sur le périphérique.", @"")];
        }
    } else if(indexPath.section == 2) {
        [[self sharedContentManager] disassociateDeviceWithToken:[OpenUDID value]];

        //
        [self setLoading:YES withTitle:NSLocalizedString(@"Désassociation de l'iPad", @"")];
    }
}

#pragma mark --
#pragma mark LoginViewControllerDelegate
- (void)loginController:(LoginViewController *)controller didAskLoginWithPublicId:(NSString *)publicId secretKey:(NSString *)secretKey {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	// Set login
    [self setLoading:YES withTitle:NSLocalizedString(@"Identification en cours", @"")];

    [self sharedContentManager].publicId = publicId;
    [self sharedContentManager].secretKey = secretKey;
    [[self sharedContentManager] fetchSurveysList];
}

- (void)loginControllerDidAskUserForm:(LoginViewController *)controller {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	SurveyConfiguration *c = [SurveyConfiguration configuration];
    if(c != nil) {
// begin cbleu fix
// modif pour finir l'animation de sortie avant le debut de l'ajout
//        [loginController dismissViewControllerAnimated:NO completion:nil];
// end cbleu fix
        [self launchUserForm:nil];
        // Should display loginController again if the user asks to come back to admin
// begin cbleu fix
// le flag à YES fait revenir à l'écran de login => supprimé
//        shouldDisplayLoginController = YES;
// end cbleu fix
    }
}

#pragma mark --
#pragma mark ContentManagerSubdelegate
// Not used here
- (void)contentManagerDidUpdateDevice:(ContentManager *)manager {
    // Not loading anymore
    [self setLoading:NO withTitle:nil];
}

// Not used here
- (void)contentManagerDidPostSurveyResults:(ContentManager *)manager {
    // Not loading anymore
    [self setLoading:NO withTitle:nil];
}

// Not used here
- (void)contentManager:(ContentManager *)manager didUpdateProgress:(double *)progress {}



// Used here
- (void)contentManager:(ContentManager *)manager didFetchSurveyConfiguration:(SurveyConfiguration *)configuration {
    
    // Deleting former stuff
    NSError *error = nil;

    // Erasing previous form content
    [@"" writeToFile:[UrlHelper formResultsFilePath]  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous form results : %@", error);
    }
    
    // Erasing previous optin content
    [@"" writeToFile:[UrlHelper optinResultsFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous optin results : %@", error);
    }

    // Setting the new configuration
    [AppCredentials setCurrentSurveyId:configuration.surveyId];
    [AppCredentials setCurrentSurveyDeploymentId:configuration.surveyDeploymentId];
    [self.tableView reloadData];

    // Not loading anymore
    [self setLoading:NO withTitle:nil];
}

// Used here
- (void)contentManager:(ContentManager *)manager didFetchSurveysList:(NSArray *)surveys {

    [loginController dismissViewControllerAnimated:YES completion:nil];

    // 
    [allowedSurveys removeAllObjects];
    [allowedSurveys addObjectsFromArray:surveys];

    // Reloading view
    [self.tableView reloadData];
    
    // Storing credentials
    [AppCredentials setPublicId:loginController.loginTextField.text
                      secretKey:loginController.passwordTextField.text
               deviceIdentifier:@"_"];

    // Not loading anymore
    [self setLoading:NO withTitle:nil];
}

// Used here
- (void)contentManager:(ContentManager *)manager didFailWithError:(NSError *)error {
    if(error.code == ContentManagerErrorCodeLoginFailed) {
        // Only display error message while trying to login
        if(manager.currentOperation == ContentManagerOperationSurveysList) {
            [loginController displayErrorMessageWithTitle:NSLocalizedString(@"L'authentification a échoué", @"") message:NSLocalizedString(@"Votre identifiant et/ou mot de passe est invalide.", @"")];
        }
    } 
    // Specified credentials are already used on another device
    else if(error.code == ContentManagerErrorCodeDeviceAlreadyAssociated) {
        if(manager.currentOperation == ContentManagerOperationSurveysList) {
            [loginController displayErrorMessageWithTitle:NSLocalizedString(@"Identifiants déjà utilisés", @"")
                                                  message:NSLocalizedString(@"Les identifiants que vous avez indiqués sont déjà utilisés et associés à un autre iPad.", @"")];
        }
    }

    // Not loading anymore
    [self setLoading:NO withTitle:nil];
}

- (void)contentManagerDidDisassociateDevice:(ContentManager *)manager {
    NSError *error = nil;

    // Reseting credentials
    [AppCredentials resetAll];

    // Removing surveys from the list
    [allowedSurveys removeAllObjects];

    // Erasing previous form content
    [@"" writeToFile:[UrlHelper formResultsFilePath]  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous form results : %@", error);
    }
    
    // Erasing previous optin content
    [@"" writeToFile:[UrlHelper optinResultsFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous optin results : %@", error);
    }

    [@"" writeToFile:[UrlHelper configurationFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous configuration file : %@", error);
    }

    // Displaying the login
    [self displayLoginScreen:nil];

    //
    [self.tableView reloadData];
    
    [loginController displayErrorMessageWithTitle:NSLocalizedString(@"L'iPad a bien été désassocié", @"")
                                          message:NSLocalizedString(@"Votre périphérique peut désormais être associé avec un autre compte inquire.", @"")];
    
    [self setLoading:NO withTitle:nil];
}

- (ContentManager *)sharedContentManager {
    inquireAppDelegate *d = (inquireAppDelegate *)[UIApplication sharedApplication].delegate;
    return d.contentManager;
}

#pragma mark --
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex && configurationToLoad >= 0) {
        SurveyDescription *d = [allowedSurveys objectAtIndex:configurationToLoad];
        [[self sharedContentManager] fetchSurveyConfigurationForSurveyId:d.surveyId];

        //
        [self setLoading:YES withTitle:NSLocalizedString(@"Téléchargement de l'enquête", @"")];

        configurationToLoad = -1;
    }
}

#pragma mark --
#pragma mark Private Methods
- (NSInteger)numberOfResultsToPost {
    NSError *error = nil;
    NSString *csvContent = [NSString stringWithContentsOfFile:[UrlHelper formResultsFilePath]
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    if(error != nil) {
        return 0;
    }

    return [[csvContent componentsSeparatedByString:@"\r\n"] count] - 1;
}

- (void)displayLoginScreen:(id)sender {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
    loginController.delegate = self;

    /*
    if(!shouldDisplayLoginController) {
        [self presentModalViewController:loginController animated:NO];
    } else {
        [self presentModalViewController:loginController animated:NO];
    }
     */
    [self presentViewController:loginController animated:NO completion:nil];
}

- (void)launchUserForm:(id)sender {
	NSLog(@"%s", __PRETTY_FUNCTION__);
//	ALog(@"debug ...");

    SurveyConfiguration *c = [SurveyConfiguration configuration];

    if(c == nil) {
        [loginController displayErrorMessageWithTitle:NSLocalizedString(@"Aucune enquête sélectionnée", @"")
                                              message:NSLocalizedString(@"Vous n'avez sélectionné aucune enquête à utiliser.", @"")];
        return;
    }
// begin cbleu fix
// gestion du flag pour ne pas avoir un retour intempestif au login
//    shouldDisplayLoginController = YES;
// end cbleu fix
	
    UserMainViewController *vc = [[UserMainViewController alloc] initWithNibName:@"UserMainView" bundle:nil];
    vc.configuration = c;
	// begin cbleu fix
	// manage flag to ask login
	vc.adminVC = self;
    
// begin cbleu fix
// Utiliser le parametre sender pour savoir si l'action arrive de la fenetre login ou admin
	if(sender){
		[self.navigationController presentViewController:vc animated:NO completion:nil];
	}else{
		// enchainement des animations pour ne pas provoquer d'erreur
		[loginController dismissViewControllerAnimated:NO completion:^{
			[self.navigationController presentViewController: vc animated:YES completion: nil];
		}];
	}
//end cbleu fix
}


- (void)setLoading:(BOOL)loading withTitle:(NSString *)title {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    if(loading && !loadingAlertView) {
        loadingAlertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:@"\n\n"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading startAnimating];
        [loadingAlertView addSubview:loading];
        [loadingAlertView show];
        loading.center = CGPointMake(141, loadingAlertView.frame.size.height/2.0);
    } else if(!loading && loadingAlertView) {
        [loadingAlertView dismissWithClickedButtonIndex:0 animated:YES];
        loadingAlertView = nil;
    }

    [self.tableView reloadData];
}



@end
