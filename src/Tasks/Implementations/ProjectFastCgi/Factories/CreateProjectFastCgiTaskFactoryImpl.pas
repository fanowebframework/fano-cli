(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateProjectFastCgiTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf;

type

    (*!--------------------------------------
     * Factory class for create project task for
     * FastCGI web application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateProjectFastCgiTaskFactory = class(TInterfacedObject, ITaskFactory)
    public
        function build() : ITask;
    end;

implementation

uses

    TextFileCreatorIntf,
    TextFileCreatorImpl,
    ContentModifierIntf,
    ContentModifierImpl,
    DirectoryCreatorImpl,
    InitGitRepoTaskImpl,
    CommitGitRepoTaskImpl,
    CreateDirTaskImpl,
    CreateAppConfigsTaskImpl,
    CreateAdditionalFilesTaskImpl,
    CreateShellScriptsTaskImpl,
    CreateFcgiAppBootstrapTaskImpl,
    CreateProjectTaskImpl,
    InvRunCheckTaskImpl,
    EmptyDirCheckTaskImpl;

    function TCreateProjectFastCgiTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
        createPrjTask : ITask;
        invRunCheckTask : ITask;
    begin
        //TODO: refactor as this is similar to TCreateProjectScgiTaskFactory
        //or TCreateProjectTaskFactory
        textFileCreator := TTextFileCreator.create();
        contentModifier := TContentModifier.create();
        createPrjTask := TCreateProjectTask.create(
            TCreateDirTask.create(TDirectoryCreator.create()),
            TCreateShellScriptsTask.create(textFileCreator, contentModifier, 'bin'),
            TCreateAppConfigsTask.create(textFileCreator, contentModifier),
            TCreateAdditionalFilesTask.create(textFileCreator, contentModifier),
            TCreateFcgiAppBootstrapTask.create(textFileCreator, contentModifier),
            TInitGitRepoTask.create(TCommitGitRepoTask.create())
        );

        //protect to avoid accidentally creating another project inside Fano-CLI
        //project directory structure
        invRunCheckTask := TInvRunCheckTask.create(createPrjTask);

        //protect to avoid accidentally creating project inside
        //existing and non empty directory
        result := TEmptyDirCheckTask.create(invRunCheckTask);
    end;

end.
