abstract type AbstractModel end
abstract type AbstractDialogModel <: AbstractModel end
abstract type AbstractStatus <: AbstractModel end
abstract type AbstractDisplayProperties end
abstract type AbstractOperation end
abstract type AbstractImporter <: AbstractOperation end
abstract type AbstractExporter <: AbstractOperation end
abstract type AbstractControl <: AbstractOperation end
abstract type AbstractDialogControl <: AbstractControl end
abstract type AbstractSchema <: AbstractModel end
abstract type AbstractVendor end
abstract type AbstractProduct end
abstract type AbstractData end
abstract type AbstractLayout <: AbstractDisplayProperties end
abstract type AbstractNestedIntervalControl <: AbstractControl end
abstract type AbstractPlotControl <: AbstractControl end
abstract type AbstractContext end
abstract type AbstractPlotContext <: AbstractContext end
