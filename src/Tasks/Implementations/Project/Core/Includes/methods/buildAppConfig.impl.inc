(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
strBuildConfigMethodImpl : string =
    '    function TAppServiceProvider.buildAppConfig(const container : IDependencyContainer) : IAppConfiguration;' + LineEnding +
    '    begin' + LineEnding +
    '[[CONFIG_IMPL_SECTION]]' + LineEnding +
    '    end;' + LineEnding +